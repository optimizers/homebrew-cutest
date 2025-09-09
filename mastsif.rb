class Mastsif < Formula
  desc "SIF problem collection"
  homepage "https://bitbucket.org/optrove/sif"
  url "https://bitbucket.org/optrove/sif/get/v2.5.2.tar.gz"
  sha256 "cfc7066c1e3d2026a00529aa7a857a0853fb148ee62231ea4d12e7b0044d23e8"

  head "https://bitbucket.org/optrove/sif.git", branch: "master"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/mastsif-2.5.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf8a6bd777de0c870baf342ee7e924c1605a72835d9bdd71a37f5dd9f1f8b87"
    sha256 cellar: :any_skip_relocation, ventura:       "5abcbc290b1778a41b2ce3e035edf944b26eccb457a5d544b2fdc719fa9a5309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96694f8bdca3a0daab5539e95739b389c0051fc3b6c57b5e63d5e1ef413b10cf"
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
