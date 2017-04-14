# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super(*args + ["--username", "anonymous"])
  end
end

class Mastsif < Formula
  desc "SIF problem collection"
  homepage "http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki"
  url "https://gitlab.com/dpo/mastsif-mirror/repository/archive.tar.bz2?ref=v0.2"
  sha256 "7e8ddbfc6cad69a8b0870e52cb6772fc575981121320dfcd7d03478a8c55f8ed"
  head "http://ccpforge.cse.rl.ac.uk/svn/cutest/sif/trunk", :using => AnonymousSubversionDownloadStrategy

  keg_only "This formula only installs data files"

  def install
    pkgshare.install Dir["*"]
    Pathname.new("#{prefix}/mastsif.bashrc").write <<-EOF.undent
      export MASTSIF=#{opt_share}/mastsif
    EOF
  end

  def caveats; <<-EOS.undent
    In your ~/.bashrc, add the line
    . #{prefix}/mastsif.bashrc
    EOS
  end

  test do
    File.exist? pkgshare/"BRAINPC1.SIF"
  end
end
