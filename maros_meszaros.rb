# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super(*args + ["--username", "anonymous"])
  end
end

class MarosMeszaros < Formula
  desc "Maros and Meszaros SIF problems"
  homepage "http://www.cuter.rl.ac.uk/Problems/marmes.shtml"
  url "https://github.com/optimizers/maros-meszaros-mirror/archive/v0.1.tar.gz"
  sha256 "eddc5e831f14be08e823d464ccb78834ef9e9120211f00f7724c0258c64fc14c"
  head "http://ccpforge.cse.rl.ac.uk/svn/cutest/marosmeszaros/trunk", :using => AnonymousSubversionDownloadStrategy

  keg_only "This formula only installs data files"

  def install
    (share / "maros_meszaros").install Dir["*.SIF"]
  end

  test do
    File.exist? pkgshare/"CVXQP3_L.SIF"
  end
end
