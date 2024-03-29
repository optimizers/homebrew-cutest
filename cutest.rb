class Cutest < Formula
  desc "Constrained and Unconstrained Testing Environment on steroids"
  homepage "https://github.com/ralna/CUTEst/wiki"
  url "https://github.com/ralna/CUTEst/archive/v2.0.2.tar.gz"
  sha256 "16ff35ff5956dfc6715250a26f7e5fa171b166fea5a60aeee2d6e232b22de954"
  revision 2

  head "https://github.com/ralna/CUTEst.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/cutest-2.0.2_2"
    sha256 cellar: :any,                 big_sur:      "3736f4dab95f3c613e2aab4f2a221de645c25008ed518b77fc2683003c88892f"
    sha256 cellar: :any,                 catalina:     "e71b6f3e2be9505a17af5747e7d3dff6a6c13eabff10f8fe877f11b7786bf07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "23af7d594787327e49814ba5fc4a2cc45b9a9fca69fb4579ae44e9d3e8cbf288"
  end

  option "with-matlab", "Compile with Matlab support"
  option "without-single", "Compile without single support"

  depends_on "gcc"

  depends_on "optimizers/cutest/archdefs"
  depends_on "optimizers/cutest/gsl@1"
  depends_on "optimizers/cutest/sifdecode"
  env :std

  patch :DATA

  def install
    ENV.deparallelize
    toolset = build.with?("matlab") ? "1" : "2"
    single = build.with?("single") ? "y" : "n"
    precisions = build.with?("single") ? ["single", "double"] : ["double"]

    if OS.mac?
      machine, key = Hardware::CPU.is_64_bit? ? %w[mac64 13] : %w[mac 12]
      arch = "osx"
      fcomp = "2"
      ccomp = "5"
      Pathname.new("cutest.input").write <<~EOF
        #{key}
        #{fcomp}
        #{toolset}
        #{ccomp}
        nnyd#{single}
      EOF
    else
      machine = "pc64"
      arch = "lnx"
      fcomp = "5"
      ccomp = "7"
      Pathname.new("cutest.input").write <<~EOF
        6
        2
        #{fcomp}
        #{toolset}
        #{ccomp}
        nnyd#{single}
      EOF
    end

    ENV["ARCHDEFS"] = Formula["archdefs"].opt_libexec
    ENV["SIFDECODE"] = Formula["sifdecode"].opt_libexec
    system "./install_cutest < cutest.input"

    # Build shared libraries.
    if OS.mac?
      so = "dylib"
      all_load = "-Wl,-all_load"
      noall_load = "-Wl,-noall_load"
      extra = ["-Wl,-undefined", "-Wl,dynamic_lookup", "-headerpad_max_install_names"]
    else
      so = "so"
      all_load = "-Wl,-whole-archive"
      noall_load = "-Wl,-no-whole-archive"
      extra = []
    end
    compiler = "gfo"
    precisions.each do |prec|
      cd "objects/#{machine}.#{arch}.#{compiler}/#{prec}" do
        Dir["*.a"].each do |l|
          lname = File.basename(l, ".a") + "_#{prec}.#{so}"
          system "gfortran", "-fPIC", "-shared", all_load, l, noall_load, "-o", lname, *extra
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
