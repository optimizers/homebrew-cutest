class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "https://github.com/ralna/SIFDecode/wiki"
  url "https://github.com/ralna/SIFDecode/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "c94cce76be32dc1f59be27d77b8158d39f6e5a67787cc65e9648dc51af20557e"

  head "https://github.com/ralna/SIFDecode.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/sifdecode-3.1.0"
    sha256 cellar: :any,                 arm64_tahoe:   "983cee271938950ffbcdd58adf928444179bc9d9a21582ce7e4e7b1e2192b049"
    sha256 cellar: :any,                 arm64_sequoia: "b3458eda1faa6ab82a5f4b15e21c91ed103d9f4399a8b03a113f39e18d96aafa"
    sha256 cellar: :any,                 arm64_sonoma:  "2b301bdbb23afe3add7fd3de862b38cc10fa1bd1a1258bf268d7d7abb5585152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80cf18572151b4e1dfe05580bfe5acb44520376e4d3c12c8a49729025d7dcd57"
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
