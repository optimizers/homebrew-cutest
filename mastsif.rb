class Mastsif < Formula
  desc "SIF problem collection"
  homepage "https://bitbucket.org/optrove/sif"
  url "https://bitbucket.org/optrove/sif/get/v0.5.tar.bz2"
  sha256 "19c1549c325dd2e431fd6f54392ed8598a3017b751f433da8891d711d34348b6"
  head "https://bitbucket.org/optrove/sif.git"

  keg_only "this formula only installs data files"

  def install
    pkgshare.install Dir["*"]
    Pathname.new("#{prefix}/mastsif.bashrc").write <<~EOF
      export MASTSIF=#{opt_share}/mastsif
    EOF
  end

  def caveats; <<~EOS
    In your ~/.bashrc, add the line
    . #{prefix}/mastsif.bashrc
  EOS
  end

  test do
    File.exist? pkgshare/"BRAINPC1.SIF"
  end
end
