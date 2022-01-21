class Netlib < Formula
  desc "All NETLIB SIF problems"
  homepage "https://bitbucket.org/optrove/netlib-lp"
  url "https://bitbucket.org/optrove/netlib-lp/get/v0.1.tar.gz"
  sha256 "e5b7d4128a0bde757ac59182228f80a33828ccc62c1764a33de722b096c0dd9a"
  revision 2

  head "https://bitbucket.org/optrove/netlib-lp.git"

  keg_only "this formula only installs data files"

  def install
    pkgshare.install Dir["*.SIF"]
  end

  test do
    File.exist? pkgshare/"AFIRO.SIF"
  end
end
