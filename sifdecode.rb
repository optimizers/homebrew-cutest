class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "https://github.com/ralna/SIFDecode/wiki"
  url "https://github.com/ralna/SIFDecode/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "f1f873b3b36233a893d6d593fcd3264cd5310e41916d30206a16f787b62c7f88"

  head "https://github.com/ralna/SIFDecode.git"

  bottle do
    root_url "https://github.com/optimizers/homebrew-cutest/releases/download/sifdecode-2.0.1_2"
    sha256 cellar: :any,                 big_sur:      "c781d13ea2ece599788b1caae6151c7401e01cec1f26cb3ad4f8f87175be8e1b"
    sha256 cellar: :any,                 catalina:     "e3369da43f231fa1e82e9b1245d7ce93527e7d79beed3750ba8853b85d9fda43"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "26b481b4b7b26ef599d4602a5d5019d4b2af2cd904375f485dc5be186a0b1c63"
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
