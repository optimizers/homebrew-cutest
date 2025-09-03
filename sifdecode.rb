class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "https://github.com/ralna/SIFDecode/wiki"
  url "https://github.com/ralna/SIFDecode/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "a419feb753195bd5e32a2f9b96785450d2a4e280280c349cce1dfd93bdc692e5"

  head "https://github.com/ralna/SIFDecode.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/sifdecode-2.4.2"
    sha256 cellar: :any,                 arm64_sonoma: "b5574e4ad972de4aa39ed58c2be575577a5d9ca65881a53832f667f0c38226de"
    sha256 cellar: :any,                 ventura:      "131da9e505cf149a60fd1627d9c516cd83dc128a93a08249716629c2bb3fe6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "697cf1292ca0b5bae7084bc4520b0382f8aba92e1e4f0294ef01c694555ab9ca"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc"

  def install
    system "meson", "setup", "build", "-Ddefault_library=shared", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    system "meson", "test", "-C", "build"

    (share/"sifdecode").install "doc"
    rm "man/man1/makedocs"
    share.install "man"
    libexec.install "sif"
  end

  test do
    cd testpath do
      system "#{bin}/sifdecoder_standalone", "-sp", "#{opt_libexec}/sif/ROSENBR.SIF"
      system "#{bin}/sifdecoder_standalone", "-dp", "#{opt_libexec}/sif/ROSENBR.SIF"
      system "#{bin}/sifdecoder_standalone", "-qp", "#{opt_libexec}/sif/ROSENBR.SIF"
    end
  end
end
