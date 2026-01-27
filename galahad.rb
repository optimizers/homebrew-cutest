class Galahad < Formula
  desc "Library of modern Fortran modules for nonlinear optimization"
  homepage "https://github.com/ralna/GALAHAD"
  url "https://github.com/ralna/GALAHAD/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "132be2493829afa4b8d0dc60f8e8dd5f9ceaf30a4df58db49e5efade5ffc7ce5"
  revision 1

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
  depends_on "metis"
  depends_on "openblas"

  depends_on "optimizers/cutest/cutest"

  fails_with :clang

  resource "mumps" do
    url "https://mumps-solver.org/MUMPS_5.8.1.tar.gz"
    sha256 "e91b6dcd93597a34c0d433b862cf303835e1ea05f12af073b06c32f652f3edd8"
  end

  def install
    ENV.delete("MPICC")
    ENV.delete("MPICXX")
    ENV.delete("MPIFC")

    resource("mumps").stage do
      cp "Make.inc/Makefile.inc.generic.SEQ", "Makefile.inc"
      make_args = ["RANLIB=echo", "FC=gfortran", "FL=gfortran"]
      if OS.mac?
        make_args << "AR = gfortran -dynamiclib -undefined dynamic_lookup -Wl,-install_name,#{lib}/$(notdir $@) -o"
      end

      make_args << "LIBEXT=.so" if OS.linux?
      make_args << "LIBEXT=.dylib" if OS.mac?

      optf = ["OPTF=-O -fPIC"]
      gcc_major_ver = Formula["gcc"].any_installed_version.major
      optf << "-fallow-argument-mismatch" if gcc_major_ver >= 10
      make_args << optf.join(" ")
      make_args << "OPTC=-O -fPIC -I."
      orderingsf = "-Dpord"

      metis_libs = ["-L#{Formula["metis"].opt_lib}", "-lmetis"]
      make_args += ["LMETISDIR=#{Formula["metis"].opt_lib}",
                    "IMETIS=#{Formula["metis"].opt_include}",
                    "LMETIS=#{metis_libs.join(" ")}"]
      orderingsf << " -Dmetis"

      make_args << "ORDERINGSF=#{orderingsf}"

      blas_lib = ["-L#{Formula["openblas"].opt_lib}", "-lopenblas"]
      make_args << "LIBBLAS=#{blas_lib.join(" ")}"
      make_args << "LAPACK=#{blas_lib.join(" ")}"

      ENV.deparallelize { system "make", "all", *make_args }

      (buildpath/"mumps_include").install Dir["include/*.h", "libseq/mpi.h"]
      lib.install Dir[
        "lib/#{shared_library("*")}",
        "libseq/#{shared_library("*")}",
        "PORD/lib/#{shared_library("*")}",
      ]
    end

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
      "-Dlibmumps_path=#{lib}",
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
