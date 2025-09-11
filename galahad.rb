class Galahad < Formula
  desc "Library of modern Fortran modules for nonlinear optimization"
  homepage "https://github.com/ralna/GALAHAD"
  url "https://github.com/ralna/GALAHAD/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "132be2493829afa4b8d0dc60f8e8dd5f9ceaf30a4df58db49e5efade5ffc7ce5"

  head "https://github.com/ralna/GALAHAD.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/galahad-5.3.0"
    sha256 cellar: :any, arm64_sequoia: "4f6bcfaee9349c6f54bc32bbf62ad78cc84ba47a878bfe3d640d495367464ac3"
    sha256 cellar: :any, ventura:       "053ee3e2e9c4af94044c301b9eb5c870e2bf9407da58cf75fb8ebb243172f97a"
    sha256               x86_64_linux:  "b871225f54183309d6a088574de15a43a9fc53b9fff819ed7fc50b44afd4d5e1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "gcc"
  depends_on "hwloc"
  depends_on "openblas"

  depends_on "optimizers/cutest/cutest"

  fails_with :clang

  def install
    # Environment variables for the unit tests
    ENV["OMP_CANCELLATION"] = "TRUE"
    ENV["OMP_PROC_BIND"] = "TRUE"
    ENV["GALAHAD"] = Pathname.pwd

    meson_args = [
      "-Dmodules=true",
      "-Dtests=true",
      "-Dbinaries=true",
      "-Dlibcutest_path=#{Formula["cutest"].opt_lib}",
      "-Dlibcutest_modules=#{Formula["cutest"].opt_prefix}/modules",
      "-Dciface=true",
      "-Dquadruple=true",
      "-Db_sanitize=none", # https://github.com/ralna/GALAHAD/pull/386
    ]

    system "meson",
           "setup",
           "build",
           *meson_args,
           *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    system "meson", "test", "-C", "build"

    (share/"galahad").install "doc"
    share.install "man"
  end

  # test do
  #   cd testpath do
  #   end
  # end
end
