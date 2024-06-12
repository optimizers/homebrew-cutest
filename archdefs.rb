class Archdefs < Formula
  desc "Architecture definition files for CUTEst"
  homepage "https://github.com/ralna/ARCHDefs/wiki"
  url "https://github.com/ralna/ARCHDefs/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "74ff6cf803a02a3bd2ab8479cd45e98e443351b8b5f78320f19d3b4ec0a5ba0d"

  head "https://github.com/ralna/ARCHDefs.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/archdefs-2.2.7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "3e8fcf4255ba9c52f7624c4deebe2a829180f1f0e8d1c2539761ed5f000e1d85"
    sha256 cellar: :any_skip_relocation, ventura:      "b714a83fd837e651b832a6302a3ca66d729f3f7cfe833164c967b6e1fa7d3ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dde4c2bb52e67fe3a0290905410d9b3fcdea3e546275c90436e7524357f90c7c"
  end

  keg_only "this formula only installs data files"

  def install
    (libexec / "bin").install Dir["bin/*"]
    bin.install_symlink "#{libexec}/bin/install_optsuite"

    # let user specify what version of gcc/gfortran they wish to use
    if OS.mac?
      mach = Hardware::CPU.is_64_bit? ? "mac64" : "mac"
      arch = "osx"
    else
      mach = "pc64"
      arch = "lnx"
    end
    if ENV["CUTEST_GFORTRAN"]
      inreplace "compiler.#{mach}.#{arch}.gfo", "FORTRAN='gfortran'", "FORTRAN=#{ENV["CUTEST_GFORTRAN"]}"
    end
    inreplace "ccompiler.#{mach}.#{arch}.gcc", "CC=gcc", "CC=#{ENV["CUTEST_GCC"]}" if ENV["CUTEST_GCC"]

    libexec.install Dir["ccompiler*"], Dir["compiler*"], Dir["system*"]
    Pathname.new("#{prefix}/archdefs.bashrc").write <<~EOF
      export ARCHDEFS=#{opt_libexec}
    EOF
  end

  def caveats
    <<~EOS
      In your ~/.bashrc, add the line
      . #{prefix}/archdefs.bashrc
    EOS
  end

  test do
    File.file? opt_libexec/"compiler.mac64.osx.gfo"
  end
end
