class MarosMeszaros < Formula
  desc "Maros and Meszaros SIF problems"
  homepage "https://bitbucket.org/optrove/maros-meszaros"
  url "https://bitbucket.org/optrove/maros-meszaros/get/v0.1.tar.gz"
  sha256 "4ac6b28429c22b87a8ab402a7927698220df575cf9b8966f436f0d82c3ccca16"
  revision 1

  head "https://optimizer@bitbucket.org/optrove/maros-meszaros.git"

  keg_only "this formula only installs data files"

  def install
    pkgshare.install Dir["*.SIF"]
  end

  test do
    File.exist? pkgshare/"CVXQP3_L.SIF"
  end
end
