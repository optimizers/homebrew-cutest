# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super(*args + ["--username", "anonymous"])
  end
end

class Archdefs < Formula
  desc "Architecture definition files for CUTEst"
  homepage "http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki"
  url "https://github.com/optimizers/archdefs-mirror/archive/v0.2.tar.gz"
  sha256 "43b1134cf302e2a1de0d3b33c2a0bcd73573a3e20f50de096e16ee34405cc175"
  head "https://ccpforge.cse.rl.ac.uk/svn/cutest/archdefs/trunk", :using => AnonymousSubversionDownloadStrategy

  keg_only "This formula only installs data files"

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
    Pathname.new("#{prefix}/archdefs.bashrc").write <<-EOF.undent
      export ARCHDEFS=#{opt_libexec}
    EOF
  end

  def caveats; <<-EOS.undent
    In your ~/.bashrc, add the line
    . #{prefix}/archdefs.bashrc
    EOS
  end

  test do
    true
  end
end
