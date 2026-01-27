class Cutest < Formula
  desc "Constrained and Unconstrained Testing Environment on steroids"
  homepage "https://github.com/ralna/CUTEst/wiki"
  url "https://github.com/ralna/CUTEst/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "165a7127f45a95ab68bf449ae0f15d2772e61ed8232de8d7c3263993477fff94"

  head "https://github.com/ralna/CUTEst.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/cutest-2.6.0"
    sha256 cellar: :any,                 arm64_tahoe:   "c82b1a0be6efd381f03337f2588265a495cf8ebe6744a429a6ad36a37d360907"
    sha256 cellar: :any,                 arm64_sequoia: "643f016ad2e303accd3b0f71fafe280977701db961850517344eaf641b3d40f6"
    sha256 cellar: :any,                 arm64_sonoma:  "1fe438e9cf00b45ad11695e105dd65d70eeb3e9ad753316c836f2c5085961aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "180937141387eabd656380853b5461a17e6ac72aba0583e59994ddff903e6831"
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
