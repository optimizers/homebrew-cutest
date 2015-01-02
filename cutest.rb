# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super(*args + ["--username", "anonymous"])
  end
end

class Cutest < Formula
  homepage "http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki"
  head "http://ccpforge.cse.rl.ac.uk/svn/cutest/cutest/trunk", :using => AnonymousSubversionDownloadStrategy

  option "with-matlab", "Compile with Matlab support"

  depends_on "dpo/cutest/archdefs" => :build
  depends_on "dpo/cutest/sifdecode" => :build
  depends_on "homebrew/versions/gcc43" => [:build, "enable-fortran"] if build.with? "matlab" # Matworks only support gfortran 4.3.
  depends_on :fortran
  env :std

  def install
    ENV.deparallelize
    machine, mac = (MacOS.prefer_64_bit?) ? %w(mac64 13) : %w(mac 12)
    toolset = (build.with? "matlab") ? "1" : "2"

    Pathname.new("osx.input").write <<-EOF.undent
      #{mac}
      2
      #{toolset}
      4
      nnydy
    EOF

    ENV["ARCHDEFS"] = Formula["archdefs"].libexec
    ENV["SIFDECODE"] = Formula["sifdecode"].libexec
    system "./install_cutest < osx.input"

    # We only want certain links in /usr/local/bin.
    libexec.install Dir["*"]
    %w(cutest2matlab runcutest).each do |f|
      bin.install_symlink "#{libexec}/bin/#{f}"
    end

    include.install_symlink Dir["#{libexec}/include/*.h"]
    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
    man3.install_symlink Dir["#{libexec}/man/man3/*.3"]
    doc.install_symlink Dir["#{libexec}/doc/README*"], "#{libexec}/doc/pdf"
    lib.install_symlink "#{libexec}/objects/#{machine}.osx.gfo/double/libcutest.a"
    ln_sf "#{libexec}/objects/#{machine}.osx.gfo/single/libcutest.a", "#{lib}/libcutest_single.a"

    s = <<-EOS.undent
    export CUTEST=#{libexec}
    EOS
    if build.with? "matlab"
      s += <<-EOS.undent
      export MYMATLABARCH=#{machine}.osx.gfo
      export MATLABPATH=$MATLABPATH:#{libexec}/src/matlab
      EOS
    end
    (prefix / "cutest.bashrc").write(s)
  end

  test do
    ENV["ARCHDEFS"] = Formula["archdefs"].libexec
    ENV["SIFDECODE"] = Formula["sifdecode"].libexec
    ENV["CUTEST"] = libexec
    %w(gen77 gen90 genc).each do |pkg|
      system "runcutest -p #{pkg} -D #{libexec}/sif/ROSENBR.SIF"
    end
    ohai "Test results are in ~/Library/Logs/Homebrew/cutest."
  end

  def caveats
    s = <<-EOS.undent
    In your ~/.bashrc, add
    . #{prefix}/cutest.bashrc
    EOS
    if build.with? "matlab"
      s += <<-EOS.undent
        export MYMATLAB=/path/to/your/matlab

        Please also look at
          #{share}/doc/README.osx
        to set up your ~/.mexopts.sh.
      EOS
    end
    s
  end
end
