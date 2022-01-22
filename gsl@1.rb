class GslAT1 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-1.16.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-1.16.tar.gz"
  sha256 "73bc2f51b90d2a780e6d266d43e487b3dbd78945dd0b04b14ca5980fe28d2f53"
  revision 2

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/gsl@1-1.16_2"
    sha256 cellar: :any,                 big_sur:      "a709fa1756f5ed57845d60e5cb059b8ebd862facadedcdd5aa5778abc395fc76"
    sha256 cellar: :any,                 catalina:     "74325edeb3a2d7fcfbffe89f16567955ee2c8a5f4dd1f9784108765c2d4fb3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7c1d37552bdbf396eb51b583e8cfbaf76b68457a13e345f4d616e820906b3275"
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
