class Galahad < Formula
  desc "Library of modern Fortran modules for nonlinear optimization"
  homepage "https://github.com/ralna/GALAHAD"
  url "https://github.com/ralna/GALAHAD/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "ba37233b7bafa66bc2a65934003ee782b9bc8b1ab83ef7d43955fc35d3dff5d1"

  head "https://github.com/ralna/GALAHAD.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/galahad-5.4.0"
    sha256 cellar: :any, arm64_tahoe:   "3e379360170c7a9034532dc3af65c370519442ece06e77b6bd990da98a2216ad"
    sha256 cellar: :any, arm64_sequoia: "4a03ef606c83b205c7a9953b74434596e37937e9002f116cd3fd227fb99f716c"
    sha256 cellar: :any, arm64_sonoma:  "2659555b0dff4b88baccbef1a000a976d186cfa863af6b66c7ad67f8bbc82949"
    sha256               x86_64_linux:  "939bf7b8ce315978342badd82892bc39472f9f03de8b02f5ef867ee966c1f702"
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
