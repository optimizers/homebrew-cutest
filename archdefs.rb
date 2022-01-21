class Archdefs < Formula
  desc "Architecture definition files for CUTEst"
  homepage "https://github.com/ralna/ARCHDefs/wiki"
  url "https://github.com/ralna/ARCHDefs/archive/v2.0.3.tar.gz"
  sha256 "f57f7c2912187c60a988c5a5707bce783ff93d414a46dd1dc51657a4bba54fbe"
  revision 2

  head "https://github.com/ralna/ARCHDefs.git"

  keg_only "this formula only installs data files"

  def install
    (libexec / "bin").install Dir["bin/*"]
    bin.install_symlink "#{libexec}/bin/install_optsuite"

    # let user specify what version of gcc/gfortran they wish to use
    if OS.mac?
      mach = Hardware::CPU.is_64_bit? ? "mac64" : "mac"
      arch = "osx"
    else
      mach = "pc64"
      arch = "lnx"
    end
    if ENV["CUTEST_GFORTRAN"]
      inreplace "compiler.#{mach}.#{arch}.gfo", "FORTRAN='gfortran'", "FORTRAN=#{ENV["CUTEST_GFORTRAN"]}"
    end
    inreplace "ccompiler.#{mach}.#{arch}.gcc", "CC=gcc", "CC=#{ENV["CUTEST_GCC"]}" if ENV["CUTEST_GCC"]

    libexec.install Dir["ccompiler*"], Dir["compiler*"], Dir["system*"]
    Pathname.new("#{prefix}/archdefs.bashrc").write <<~EOF
      export ARCHDEFS=#{opt_libexec}
    EOF
  end

  def caveats
    <<~EOS
      In your ~/.bashrc, add the line
      . #{prefix}/archdefs.bashrc
    EOS
  end

  test do
    File.file? opt_libexec/"compiler.mac.osx.gfo"
  end
end
