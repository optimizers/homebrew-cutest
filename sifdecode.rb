class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "https://github.com/ralna/SIFDecode/wiki"
  url "https://github.com/ralna/SIFDecode/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "a419feb753195bd5e32a2f9b96785450d2a4e280280c349cce1dfd93bdc692e5"
  revision 2

  head "https://github.com/ralna/SIFDecode.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/sifdecode-2.6.4_2"
    sha256 cellar: :any,                 arm64_sequoia: "b39ed4c95065cda1fc5bc17eee30c48fbf4995d1e833fb3e0de0f7e278bf48d3"
    sha256 cellar: :any,                 ventura:       "cb54dd486fc263bbfab4754a4b30b07444ab6c2662e1d0bf5b6ec3094bf16a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3025a3c347e0f472474d8a2252120e0da72107c662bca472abd3fef403011d31"
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
