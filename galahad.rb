class Galahad < Formula
  desc "Library of modern Fortran modules for nonlinear optimization"
  homepage "https://github.com/ralna/GALAHAD"
  url "https://github.com/ralna/GALAHAD/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "132be2493829afa4b8d0dc60f8e8dd5f9ceaf30a4df58db49e5efade5ffc7ce5"

  head "https://github.com/ralna/GALAHAD.git", branch: "master"

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
