class Archdefs < Formula
  desc "Architecture definition files for CUTEst"
  homepage "https://github.com/ralna/ARCHDefs/wiki"
  url "https://github.com/ralna/ARCHDefs/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "24cdd15b4d5717ead66331e970b9ae9d168c45800b62f608e3a97deb54da383d"

  head "https://github.com/ralna/ARCHDefs.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/archdefs-2.2.8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "41c6bae8fe3864c9a6df0064075097d48b12475ce39ca89f9bdd8bf4f7d7e588"
    sha256 cellar: :any_skip_relocation, ventura:      "bef3d17ae33237c500b40a4ed4c2b04b78cea8bde5c5af1786b293456fd24c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "86d87d9363c499616af0f16a483a91f3675b35f5ad622b264a97d3f5d280dc0b"
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
