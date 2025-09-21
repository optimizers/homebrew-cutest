class Cutest < Formula
  desc "Constrained and Unconstrained Testing Environment on steroids"
  homepage "https://github.com/ralna/CUTEst/wiki"
  url "https://github.com/ralna/CUTEst/archive/refs/tags/v2.5.8.tar.gz"
  sha256 "e01ef55e3ec99fbd8b5a7989fd7e4f234ce3bef239a4685a397cbea640492fb1"

  head "https://github.com/ralna/CUTEst.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/cutest-2.5.7_2"
    sha256 cellar: :any,                 arm64_sequoia: "eec0a5331352dca8789ef4ee06d3eb058e1f8027645050c02fa66ce8a734ca63"
    sha256 cellar: :any,                 ventura:       "52d5af52b121ef854687ffb73db99682216bb15a4be1184bf28716295d3b44ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75c89c633a988632b0bb2ad543015c08334e5229961aadaa2ee004fef14d9488"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc"

  depends_on "optimizers/cutest/sifdecode"

  fails_with :clang

  def install
    meson_args = %w[
      -Dmodules=true
      -Dtests=true
      -Dquadruple=true
    ]
    system "meson", "setup", "build", *meson_args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    system "meson", "test", "-C", "build"

    system "meson", "setup", "build_shared", "-Ddefault_library=shared", *meson_args, *std_meson_args
    system "meson", "compile", "-C", "build_shared", "--verbose"
    system "meson", "install", "-C", "build_shared"
    system "meson", "test", "-C", "build_shared"

    # TODO: runcutest must be adapted
    # bin.install "bin/runcutest"
    (share/"cutest").install "doc"
    rm "man/man1/makedocs"
    rm "man/man3/makedocs"
    share.install "man"
    libexec.install "sif"
  end

  # test do
  #   cd testpath do
  #   end
  # end
end
