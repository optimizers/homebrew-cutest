# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super(*args + ["--username", "anonymous"])
  end
end

class Netlib < Formula
  desc "Netlib SIF problems"
  homepage "http://www.cuter.rl.ac.uk/Problems/netlib.shtml"
  url "ftp://ftp.numerical.rl.ac.uk/pub/cuter/netlib.tar.gz"
  sha256 "88f9e05db532535a7356cf16d604c7014feccd6e51062910b0c81fd248c41093"

  keg_only "This formula only installs data files"

  def install
    pkgshare.install Dir["*.SIF"]
    Pathname.new("#{prefix}/netlib.bashrc").write <<-EOF.undent
      export NETLIB=#{opt_share}/netlib
    EOF
  end

  test do
    File.exist? pkgshare/"AFIRO.SIF"
  end
end
