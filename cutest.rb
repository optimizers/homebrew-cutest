class Cutest < Formula
  desc "Constrained and Unconstrained Testing Environment on steroids"
  homepage "https://github.com/ralna/CUTEst/wiki"
  url "https://github.com/ralna/CUTEst/archive/refs/tags/v2.5.7.tar.gz"
  sha256 "8d8dbb60fcbf7576130e648446d7b401a50c1583693a19f3acc8533602cfda8f"

  head "https://github.com/ralna/CUTEst.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/cutest-2.1.0_3"
    sha256 cellar: :any,                 arm64_sonoma: "75e848b0c872ce2947febaa7b973cbcec49f0150b87c980e8596b89feb7bdb8f"
    sha256 cellar: :any,                 ventura:      "02f2b5957d31ad4173717c41ef61073974829a0acb6dd1e710a3d78b9192499c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "665c42d63b12a621abb8adb708a084dc117858978936744d3e879ab921013da6"
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
