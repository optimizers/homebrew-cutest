# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super(*args + ["--username", "anonymous"])
  end
end

class MarosMeszaros < Formula
  homepage "http://www.cuter.rl.ac.uk/Problems/marmes.shtml"
  head "http://ccpforge.cse.rl.ac.uk/svn/cutest/marosmeszaros/trunk", :using => AnonymousSubversionDownloadStrategy
  url "ftp://ftp.numerical.rl.ac.uk/pub/cuter/marosmeszaros.tar.gz"
  sha256 "ad8c65c4122a2acfd6d60acdd6bc4bb1a15f79dd8ed4be646fbe7348f938a6f9"
  version "1.0"

  keg_only "This formula only installs data files"

  def install
    (share / "maros_meszaros").install Dir["*.SIF"]
  end

  test do
    true
  end
end
