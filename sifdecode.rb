class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "https://github.com/ralna/SIFDecode/wiki"
  url "https://github.com/ralna/SIFDecode/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "deea88c087563a49602ec2e758aeb3a75a5b92dbd449ecef14b87b29ff294287"

  head "https://github.com/ralna/SIFDecode.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/sifdecode-2.4.1"
    sha256 cellar: :any,                 arm64_sonoma: "6f8f28db0c9e1748ee87263b0c4ed328992f2a766e4989cd27b12e88d4f7684f"
    sha256 cellar: :any,                 ventura:      "06ef13a10255d8fe074052a45a919662fa42ad51d62d7adcbfcb60d7503c4f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6730bf77f9aecd62b1efc76cd7d6f9d36a6a0ffa89deef41cf5329e64db46f49"
  end

  depends_on "optimizers/cutest/archdefs" => :build
  depends_on "gcc"
  env :std

  def install
    if OS.mac?
      machine, key = Hardware::CPU.is_64_bit? ? %w[mac64 2] : %w[mac 4]
      arch = "osx"
      comp = "4"
      Pathname.new("sifdecode.input").write <<~EOF
        #{key}
        n#{comp}
        ny
      EOF
    else
      machine = "pc64"
      arch = "lnx"
      comp = "8"
      Pathname.new("sifdecode.input").write <<~EOF
        1
        1
        n#{comp}
        ny
      EOF
    end

    ENV["ARCHDEFS"] = Formula["archdefs"].opt_libexec
    ENV.deparallelize do
      system "./install_sifdecode < sifdecode.input"
    end

    # We only want certain links in /usr/local/bin.
    libexec.install Dir["*"]
    %w[sifdecoder classall select].each do |f|
      bin.install_symlink "#{libexec}/bin/#{f}"
    end

    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
    doc.install_symlink Dir["#{libexec}/doc/*"]
    lib.install_symlink Dir["#{libexec}/objects/#{machine}.#{arch}.gfo/double/*.a"]

    compiler = "gfo"
    (prefix/"sifdecode.bashrc").write <<~EOF
      export SIFDECODE=#{opt_libexec}
      export MYARCH=#{machine}.#{arch}.#{compiler}
    EOF
    (prefix/"sifdecode.machine").write <<~EOF
      #{machine}
      #{arch}
      #{compiler}
    EOF
  end

  def caveats
    <<~EOS
      In your ~/.bashrc, add the line
      . #{prefix}/sifdecode.bashrc
    EOS
  end

  test do
    machine, arch, compiler = File.read(opt_prefix/"sifdecode.machine").split
    ENV["ARCHDEFS"] = Formula["archdefs"].opt_libexec
    ENV["SIFDECODE"] = opt_libexec
    ENV["MYARCH"] = "#{machine}.#{arch}.#{compiler}"
    ENV["MASTSIF"] = "#{opt_libexec}/sif"

    cd testpath do
      system "#{bin}/sifdecoder", "#{opt_libexec}/sif/ROSENBR.SIF"
    end
  end
end
