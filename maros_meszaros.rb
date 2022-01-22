class MarosMeszaros < Formula
  desc "Maros and Meszaros SIF problems"
  homepage "https://bitbucket.org/optrove/maros-meszaros"
  url "https://bitbucket.org/optrove/maros-meszaros/get/v0.1.tar.gz"
  sha256 "4ac6b28429c22b87a8ab402a7927698220df575cf9b8966f436f0d82c3ccca16"
  revision 2

  head "https://optimizer@bitbucket.org/optrove/maros-meszaros.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/maros_meszaros-0.1_2"
    sha256 cellar: :any_skip_relocation, big_sur:      "4d7dc4185284cf22fc683edc319579a1be086365271059b41fdf6c58b1086a12"
    sha256 cellar: :any_skip_relocation, catalina:     "83fab126dba8f9c45da73d8a75b6e22ff7f8e43b4c6da38df1c7bc12b578d577"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "06307ee756a1dbee2a3dabe61e2d900ed7994c032b8aa0f34c2a9d31d8283af3"
  end

  keg_only "this formula only installs data files"

  def install
    pkgshare.install Dir["*.SIF"]
  end

  test do
    File.exist? pkgshare/"CVXQP3_L.SIF"
  end
end
