class Archdefs < Formula
  desc "Architecture definition files for CUTEst"
  homepage "https://github.com/ralna/ARCHDefs/wiki"
  url "https://github.com/ralna/ARCHDefs/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "f65444a5f85ca42664eaeb2aecae3b76cffdfde60d481298f5b06084044801df"

  head "https://github.com/ralna/ARCHDefs.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/archdefs-2.2.6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "98d02edd0742b50ab117ebb49649e69bac9f1dcb98522ca08a55d56d3d147d74"
    sha256 cellar: :any_skip_relocation, ventura:      "f5767e5f642a2e4a8b5817e305ab01e3fa4dc70b830445d7ec469bba9cfb3155"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "527e4db09ca8b29d850bb9d5e8652da1f506dcccf669a288b2719cc47cddc1dc"
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
    File.file? opt_libexec/"compiler.mac64.osx.gfo"
  end
end
