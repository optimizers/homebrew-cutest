class Cutest < Formula
  desc "Constrained and Unconstrained Testing Environment on steroids"
  homepage "https://github.com/ralna/CUTEst/wiki"
  url "https://github.com/ralna/CUTEst/archive/refs/tags/v2.5.7.tar.gz"
  sha256 "8d8dbb60fcbf7576130e648446d7b401a50c1583693a19f3acc8533602cfda8f"

  head "https://github.com/ralna/CUTEst.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/cutest-2.5.7"
    sha256 cellar: :any, ventura: "1eab74c2a4217f761bd818f1653f52f0746aa6a1f44d92faa55780303935f587"
  end

  option "with-shared", "Compile shared libraries; users will have to use CUTEst trampoline"

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
    meson_args << "-Ddefault_library=shared" if build.with? "shared"
    meson_args << "-Dquadruple=true" if build.without? "shared"
    system "meson",
           "setup",
           "build",
           *meson_args,
           *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    system "meson", "test", "-C", "build"

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
