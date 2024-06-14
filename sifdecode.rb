class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "https://github.com/ralna/SIFDecode/wiki"
  url "https://github.com/ralna/SIFDecode/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "deea88c087563a49602ec2e758aeb3a75a5b92dbd449ecef14b87b29ff294287"

  head "https://github.com/ralna/SIFDecode.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/sifdecode-2.4.2"
    sha256 cellar: :any,                 arm64_sonoma: "b5574e4ad972de4aa39ed58c2be575577a5d9ca65881a53832f667f0c38226de"
    sha256 cellar: :any,                 ventura:      "131da9e505cf149a60fd1627d9c516cd83dc128a93a08249716629c2bb3fe6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "697cf1292ca0b5bae7084bc4520b0382f8aba92e1e4f0294ef01c694555ab9ca"
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
