class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "https://github.com/ralna/SIFDecode/wiki"
  url "https://github.com/ralna/SIFDecode/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "a419feb753195bd5e32a2f9b96785450d2a4e280280c349cce1dfd93bdc692e5"
  revision 2

  head "https://github.com/ralna/SIFDecode.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/sifdecode-2.6.4_1"
    sha256 cellar: :any, ventura: "e148f26dee832bf113f2f87719269852a01fcc45ec574948bf95098b59cd80c9"
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
