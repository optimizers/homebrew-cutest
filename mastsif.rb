class Mastsif < Formula
  desc "SIF problem collection"
  homepage "https://bitbucket.org/optrove/sif"
  url "https://bitbucket.org/optrove/sif/get/v0.5.tar.gz"
  sha256 "d2a7e0956e5216a4ad2a51a3a8219711e5f4f729cb3f044d4133d8fb19d0172d"
  head "https://bitbucket.org/optrove/sif.git"
  revision 1

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
