class Archdefs < Formula
  desc "Architecture definition files for CUTEst"
  homepage "https://github.com/ralna/ARCHDefs/wiki"
  url "https://github.com/ralna/ARCHDefs/archive/v2.0.0.tar.gz"
  sha256 "c6834e7d879e70502a29ef5a906ee84d3793f3f456d80c0bf5f71712242a9edd"
  head "https://github.com/ralna/ARCHDefs.git"

  keg_only "this formula only installs data files"

  # should be part of next release
  patch :DATA

  def install
    (libexec / "bin").install Dir["bin/*"]
    bin.install_symlink "#{libexec}/bin/install_optsuite"

    # let user specify what version of gcc/gfortran they wish to use
    if OS.mac?
      mach = MacOS.prefer_64_bit? ? "mac64" : "mac"
      arch = "osx"
    else
      mach = "pc64"
      arch = "lnx"
    end
    if ENV["CUTEST_GFORTRAN"]
      inreplace "compiler.#{mach}.#{arch}.gfo", "FORTRAN='gfortran'", "FORTRAN=#{ENV["CUTEST_GFORTRAN"]}"
    end
    if ENV["CUTEST_GCC"]
      inreplace "ccompiler.#{mach}.#{arch}.gcc", "CC=gcc", "CC=#{ENV["CUTEST_GCC"]}"
    end

    libexec.install Dir["ccompiler*"], Dir["compiler*"], Dir["system*"]
    Pathname.new("#{prefix}/archdefs.bashrc").write <<~EOF
      export ARCHDEFS=#{opt_libexec}
    EOF
  end

  def caveats; <<~EOS
    In your ~/.bashrc, add the line
    . #{prefix}/archdefs.bashrc
    EOS
  end

  test do
    true
  end
end

__END__
diff --git a/ccompiler.pc64.lnx.gcc b/ccompiler.pc64.lnx.gcc
index 85e32ef..244b79a 100644
--- a/ccompiler.pc64.lnx.gcc
+++ b/ccompiler.pc64.lnx.gcc
@@ -4,13 +4,13 @@
 #  C compilation and loading
 #
 
-CC=gcc-4.9
+CC=gcc
 CCBASIC='-c -fPIC'
 CCISO='-ansi -pedantic' # -pedantic-errors'
 CCDEBUG= #-g -DDEBUG_GALAHAD
 CCFFLAGS='-lgfortran -lm'
 
-CXX=g++-4.9
+CXX=g++
 CXXBASIC='-c -std=c++11 -fPIC'
 CXXOPT=-O2
 CXXNOOPT=-O0

