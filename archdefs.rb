class Archdefs < Formula
  desc "Architecture definition files for CUTEst"
  homepage "https://github.com/ralna/ARCHDefs/wiki"
  url "https://github.com/ralna/ARCHDefs/archive/v2.0.3.tar.gz"
  sha256 "f57f7c2912187c60a988c5a5707bce783ff93d414a46dd1dc51657a4bba54fbe"
  revision 2

  head "https://github.com/ralna/ARCHDefs.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/archdefs-2.0.3_2"
    sha256 cellar: :any_skip_relocation, big_sur:      "b087b6d111c4fabe649b5f7b8429e3fed6ebcfb6a529423619b8c064a6daf95b"
    sha256 cellar: :any_skip_relocation, catalina:     "b566fbf0348bb5504201885d1c19f5ec4038d81f72aa8a6c0ec58a69be169c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b296837114cb9ad69cdd07f8e5b9764b88516f04cb523f8d4e860f39bda9fb81"
  end

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
