class Cutest < Formula
  desc "Constrained and Unconstrained Testing Environment on steroids"
  homepage "https://github.com/ralna/CUTEst/wiki"
  url "https://github.com/ralna/CUTEst/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "83557557a8c6b174e817116ddc056f4a321bc6651719b25925fff399e44b5997"
  revision 3

  head "https://github.com/ralna/CUTEst.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/cutest-2.1.0_2"
    sha256 cellar: :any,                 arm64_sonoma: "e4b0e61cdf6d40b16538ce543fed9cb3eb883e4fffcd0f16a2e89ca0bf0617f8"
    sha256 cellar: :any,                 ventura:      "091a309127bc3a0be4d0852759c3ea9eafd74a5f2ab60b2d062a714567b9fd12"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e414b35a6ceb0d0e24946944267116bd99c2045b5ceaec7f596ae391771530e1"
  end

  option "with-matlab", "Compile with Matlab support"
  option "without-single", "Compile without single support"
  option "without-quadruple", "Compile without quadruple support"

  depends_on "gcc"

  depends_on "optimizers/cutest/archdefs"
  depends_on "optimizers/cutest/gsl@1"
  depends_on "optimizers/cutest/sifdecode"
  env :std

  patch :DATA

  def install
    toolset = build.with?("matlab") ? "1" : "2"
    single = build.with?("single") ? "y" : "n"
    quadruple = build.with?("quadruple") ? "y" : "n"
    precisions = ["double"]
    build.with?("single") && precisions.append("single")
    build.with?("quadruple") && precisions.append("quadruple")

    if OS.mac?
      machine, key = Hardware::CPU.is_64_bit? ? %w[mac64 2] : %w[mac 4]
      arch = "osx"
      fcomp = "4"
      ccomp = "3"
      Pathname.new("cutest.input").write <<~EOF
        #{key}
        n#{fcomp}
        #{toolset}
        #{ccomp}
        nnyd#{single}#{quadruple}
      EOF
    else
      machine = "pc64"
      arch = "lnx"
      fcomp = "8"
      ccomp = "7"
      Pathname.new("cutest.input").write <<~EOF
        1
        1
        n#{fcomp}
        #{toolset}
        #{ccomp}
        nnyd#{single}#{quadruple}
      EOF
    end

    ENV["ARCHDEFS"] = Formula["archdefs"].opt_libexec
    ENV["SIFDECODE"] = Formula["sifdecode"].opt_libexec
    ENV.deparallelize do
      system "./install_cutest < cutest.input"
    end

    # Build shared libraries.
    if OS.mac?
      so = "dylib"
      all_load = ["-Wl,-all_load"]
      noall_load = []
      extra = ["-Wl,-undefined", "-Wl,dynamic_lookup", "-headerpad_max_install_names"]
    else
      so = "so"
      all_load = ["-Wl,-whole-archive"]
      noall_load = ["-Wl,-no-whole-archive"]
      extra = []
    end
    compiler = "gfo"
    precisions.each do |prec|
      cd "objects/#{machine}.#{arch}.#{compiler}/#{prec}" do
        Dir["*.a"].each do |l|
          lname = File.basename(l, ".a") + "_#{prec}.#{so}"
          system "gfortran", "-fPIC", "-shared", *all_load, l, *noall_load, "-o", lname, *extra
        end
      end
    end

    # We only want certain links in /usr/local/bin.
    libexec.install Dir["*"]
    %w[cutest2matlab_osx runcutest].each do |f|
      bin.install_symlink "#{libexec}/bin/#{f}"
    end

    include.install_symlink Dir["#{libexec}/include/*.h"]
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
    man3.install_symlink Dir["#{libexec}/man/man3/*.3"]
    doc.install_symlink Dir["#{libexec}/doc/README*"], "#{libexec}/doc/pdf"
    lib.install_symlink "#{libexec}/objects/#{machine}.#{arch}.#{compiler}/double/libcutest.a"
    lib.install_symlink "#{libexec}/objects/#{machine}.#{arch}.#{compiler}/double/libcutest_double.#{so}"
    ln_sf "#{libexec}/objects/#{machine}.#{arch}.#{compiler}/double/libcutest.a", "#{lib}/libcutest_double.a"
    ln_sf "#{libexec}/objects/#{machine}.#{arch}.#{compiler}/double/libcutest_double.#{so}", "#{lib}/libcutest.#{so}"
    if build.with? "single"
      ln_sf "#{libexec}/objects/#{machine}.#{arch}.#{compiler}/single/libcutest.a", "#{lib}/libcutest_single.a"
      ln_sf "#{libexec}/objects/#{machine}.#{arch}.#{compiler}/single/libcutest_single.#{so}",
            "#{lib}/libcutest_single.#{so}"
    end
    if build.with? "quadruple"
      ln_sf "#{libexec}/objects/#{machine}.#{arch}.#{compiler}/quadruple/libcutest.a", "#{lib}/libcutest_quadruple.a"
      ln_sf "#{libexec}/objects/#{machine}.#{arch}.#{compiler}/quadruple/libcutest_quadruple.#{so}",
            "#{lib}/libcutest_quadruple.#{so}"
    end

    s = <<~EOS
      export CUTEST=#{opt_libexec}
    EOS
    if build.with? "matlab"
      s += <<~EOS
        export MYMATLABARCH=#{machine}.#{arch}.#{compiler}
        export MATLABPATH=$MATLABPATH:#{opt_libexec}/src/matlab
      EOS
    end
    (prefix/"cutest.bashrc").write(s)
    (prefix/"cutest.machine").write <<~EOF
      #{machine}
      #{arch}
      #{compiler}
    EOF
  end

  def caveats
    s = <<~EOS
      In your ~/.bashrc, add
      . #{prefix}/cutest.bashrc
    EOS
    if build.with? "matlab"
      s += <<~EOS
        export MYMATLAB=/path/to/your/matlab

        Please also look at
          #{share}/doc/README.osx
        to set up your ~/.mexopts.sh.
      EOS
    end
    s
  end

  test do
    machine, arch, compiler = File.read(opt_prefix/"cutest.machine").split
    ENV["ARCHDEFS"] = Formula["archdefs"].opt_libexec
    ENV["SIFDECODE"] = Formula["sifdecode"].opt_libexec
    ENV["CUTEST"] = opt_libexec
    ENV["MYARCH"] = "#{machine}.#{arch}.#{compiler}"
    ENV["MASTSIF"] = "#{opt_libexec}/sif"

    cd testpath do
      %w[gen77 gen90 genc].each do |pkg|
        system "#{bin}/runcutest", "-p", pkg, "-D", "ROSENBR.SIF"
        system "#{bin}/runcutest", "-p", pkg, "-sp", "-D", "ROSENBR.SIF" if build.with? "single"
      end
    end
  end
end

__END__
diff --git a/bin/install_cutest_alone b/bin/install_cutest_alone
index a7edfde..cc8474b 100755
--- a/bin/install_cutest_alone
+++ b/bin/install_cutest_alone
@@ -372,8 +372,8 @@ if [[ -e $CUTEST/versions/$VERSION ]]; then
     [[ $? == 0 ]] && exit 4
 fi

-MATLABGCC="gcc-4.3"
-MATLABGFORTRAN="gfortran-4.3"
+MATLABGCC="gcc"
+MATLABGFORTRAN="gfortran"
 matlab=""

 #echo $CMP
