class Netlib < Formula
  desc "All NETLIB SIF problems"
  homepage "http://www.cuter.rl.ac.uk/Problems/netlib.shtml"
  url "https://bitbucket.org/optrove/netlib-lp/get/v0.1.tar.bz2"
  sha256 "b24eb91097ef073ff66c7c6e20b213bfe8b1be6f5dcdb5cb7de38ebc44c77f88"
  revision 1
  head "https://bitbucket.org/optrove/netlib-lp.git"

  keg_only "this formula only installs data files"

  def install
    pkgshare.install Dir["*.SIF"]
  end

  test do
    File.exist? pkgshare/"AFIRO.SIF"
  end
end
