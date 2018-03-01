class Netlib < Formula
  desc "Netlib SIF problems"
  homepage "http://www.cuter.rl.ac.uk/Problems/netlib.shtml"
  url "ftp://ftp.numerical.rl.ac.uk/pub/cuter/netlib.tar.gz"
  version "1.0"
  sha256 "88f9e05db532535a7356cf16d604c7014feccd6e51062910b0c81fd248c41093"
  keg_only "this formula only installs data files"

  def install
    pkgshare.install Dir["*.SIF"]
  end

  test do
    File.exist? pkgshare/"AFIRO.SIF"
  end
end
