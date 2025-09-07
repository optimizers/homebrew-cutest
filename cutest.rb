class Cutest < Formula
  desc "Constrained and Unconstrained Testing Environment on steroids"
  homepage "https://github.com/ralna/CUTEst/wiki"
  url "https://github.com/ralna/CUTEst/archive/refs/tags/v2.5.7.tar.gz"
  sha256 "8d8dbb60fcbf7576130e648446d7b401a50c1583693a19f3acc8533602cfda8f"
  revision 1

  head "https://github.com/ralna/CUTEst.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/cutest-2.5.7_1"
    sha256 cellar: :any, ventura: "74f46cfb6110e0f48c25978b45d7d88b5a680b463e2ea13c3d19e3e4763f5549"
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
    ]
    system "meson",
           "setup",
           "build",
           "-Dquadruple=true",
           *meson_args,
           *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    system "meson", "test", "-C", "build"

    system "meson",
           "setup",
           "build_shared",
           "-Dquadruple=true",
           "-Ddefault_library=shared",
           *meson_args,
           *std_meson_args
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
