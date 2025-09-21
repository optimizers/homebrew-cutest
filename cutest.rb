class Cutest < Formula
  desc "Constrained and Unconstrained Testing Environment on steroids"
  homepage "https://github.com/ralna/CUTEst/wiki"
  url "https://github.com/ralna/CUTEst/archive/refs/tags/v2.5.8.tar.gz"
  sha256 "e01ef55e3ec99fbd8b5a7989fd7e4f234ce3bef239a4685a397cbea640492fb1"

  head "https://github.com/ralna/CUTEst.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/cutest-2.5.8"
    sha256 cellar: :any,                 arm64_sequoia: "107eb1e6cf694afa211e49b069cfc7011bd8f89c3a1d00f203b64135db34bdfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc619ad878776ea008761712dc2a909b6758516d1fd2848901aa05638043295f"
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
