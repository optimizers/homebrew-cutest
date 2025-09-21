class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "https://github.com/ralna/SIFDecode/wiki"
  url "https://github.com/ralna/SIFDecode/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "a4e8ad664247174c1005448eeabf2dfccc96b3092b0bbfd12bed6ad35e169414"

  head "https://github.com/ralna/SIFDecode.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/sifdecode-3.0.0"
    sha256 cellar: :any,                 arm64_sequoia: "ab2794cd5bfb12fd868670440a3ebbc8e26646aef9cdad7ab141f45a9f95e618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3078561729a8a35b88bcd9a9ab4eb1f6a8612dab60f3cb8391de70924d1dbeae"
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
      system "#{bin}/sifdecoder", "-sp", "#{opt_libexec}/sif/ROSENBR.SIF"
      system "#{bin}/sifdecoder", "-dp", "#{opt_libexec}/sif/ROSENBR.SIF"
      system "#{bin}/sifdecoder", "-qp", "#{opt_libexec}/sif/ROSENBR.SIF"
    end
  end
end
