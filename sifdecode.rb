class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "https://github.com/ralna/SIFDecode/wiki"
  url "https://github.com/ralna/SIFDecode/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "a419feb753195bd5e32a2f9b96785450d2a4e280280c349cce1dfd93bdc692e5"
  revision 1

  head "https://github.com/ralna/SIFDecode.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/sifdecode-2.6.4"
    sha256 cellar: :any, ventura: "e261caadc1f4b8c4d216a394dfa2b67e39ff8673af62de0d2fea799fa77a2a20"
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
