class Netlib < Formula
  desc "All NETLIB SIF problems"
  homepage "https://bitbucket.org/optrove/netlib-lp"
  url "https://bitbucket.org/optrove/netlib-lp/get/v0.1.tar.gz"
  sha256 "e5b7d4128a0bde757ac59182228f80a33828ccc62c1764a33de722b096c0dd9a"
  revision 3

  head "https://bitbucket.org/optrove/netlib-lp.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/netlib-0.1_3"
    sha256 cellar: :any_skip_relocation, big_sur:      "fb782247d21b33eec0c490b576a76346442c6f709cc650608b90cc2d4f7b1359"
    sha256 cellar: :any_skip_relocation, catalina:     "8ec9730fc5754707f510df2f30f4496d1f4a805c3407a1128fc7a7dc01cb2baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8cccbc3f5255aec8eb7ddc9f17c47d21c76706720cdd285a61ddb8d497b369a3"
  end

  keg_only "this formula only installs data files"

  def install
    pkgshare.install Dir["*.SIF"]
  end

  test do
    File.exist? pkgshare/"AFIRO.SIF"
  end
end
