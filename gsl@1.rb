class GslAT1 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz"
  sha256 "73bc2f51b90d2a780e6d266d43e487b3dbd78945dd0b04b14ca5980fe28d2f53"
  revision 3

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/gsl@1-1.16_3"
    sha256 cellar: :any,                 arm64_sonoma: "5566635b10b1b81d41a1ae12e1426c6b2b785be3a6879b372b971f896064dfaf"
    sha256 cellar: :any,                 ventura:      "56b911175fbfbea45720141466b8016090584d03feaaa21e4ffee02289749d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9f3ed11e1252bafff9f8c701b6331c11cfab7715887e646965522ec108d3ed58"
  end

  keg_only :versioned_formula

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
