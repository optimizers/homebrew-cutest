class Mastsif < Formula
  desc "SIF problem collection"
  homepage "https://bitbucket.org/optrove/sif"
  url "https://bitbucket.org/optrove/sif/get/v2.5.2.tar.gz"
  sha256 "cfc7066c1e3d2026a00529aa7a857a0853fb148ee62231ea4d12e7b0044d23e8"

  head "https://bitbucket.org/optrove/sif.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/mastsif-0.5_2"
    sha256 cellar: :any_skip_relocation, big_sur:      "ef83954ba6ddcd0817c4dcb2755abab5177be52ce86ae264d1a4c4fdcc4f1aac"
    sha256 cellar: :any_skip_relocation, catalina:     "77681296458be8aa77d320b4ab10b5392b566bbb4933f6591004da21bd136711"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "868c58e1e757e0a5e3be1212854dc770a048eaf1a52357d99ac43ecdba38e5b2"
  end

  keg_only "this formula only installs data files"

  def install
    pkgshare.install Dir["*"]
    Pathname.new("#{prefix}/mastsif.bashrc").write <<~EOF
      export MASTSIF=#{opt_share}/mastsif
    EOF
  end

  def caveats
    <<~EOS
      In your ~/.bashrc, add the line
      . #{prefix}/mastsif.bashrc
    EOS
  end

  test do
    File.exist? pkgshare/"BRAINPC1.SIF"
  end
end
