# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super(*args + ["--username", "anonymous"])
  end
end

class Sifdecode < Formula
  desc "SIF Decoder"
  homepage "http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki"
  head "http://ccpforge.cse.rl.ac.uk/svn/cutest/sifdecode/trunk", :using => AnonymousSubversionDownloadStrategy

  option "with-pgi", "build with Portland Group compiler"

  depends_on "optimizers/cutest/archdefs" => :build
  depends_on :fortran if build.without? "pgi"
  env :std

  def install
    ENV.deparallelize

    if OS.mac?
      machine, key = (MacOS.prefer_64_bit?) ? %w[mac64 13] : %w[mac 12]
      arch = "osx"
      comp = (build.with? "pgi") ? "5" : "2"
      Pathname.new("sifdecode.input").write <<-EOF.undent
        #{key}
        #{comp}
        nny
      EOF
    else
      machine = "pc64"
      arch = "lnx"
      comp = (build.with? "pgi") ? "7" : "2"
      Pathname.new("sifdecode.input").write <<-EOF.undent
        6
        2
        #{comp}
        nny
      EOF
    end

    ENV["ARCHDEFS"] = Formula["archdefs"].libexec
    system "./install_sifdecode < sifdecode.input"

    # We only want certain links in /usr/local/bin.
    libexec.install Dir["*"]
    %w[sifdecoder classall select].each do |f|
      bin.install_symlink "#{libexec}/bin/#{f}"
    end

    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
    doc.install_symlink Dir["#{libexec}/doc/*"]
    lib.install_symlink Dir["#{libexec}/objects/#{machine}.#{arch}.gfo/double/*.a"]

    compiler = (build.with? "pgi") ? "pgf" : "gfo"
    (prefix / "sifdecode.bashrc").write <<-EOF.undent
      export SIFDECODE=#{opt_libexec}
      export MYARCH=#{machine}.#{arch}.#{compiler}
    EOF
    (prefix / "sifdecode.machine").write <<-EOF.undent
      #{machine}
      #{arch}
      #{compiler}
    EOF
  end

  def caveats; <<-EOS.undent
    In your ~/.bashrc, add the line
    . #{prefix}/sifdecode.bashrc
    EOS
  end

  test do
    machine, arch, compiler = File.read(prefix / "sifdecode.machine").split
    ENV["ARCHDEFS"] = Formula["archdefs"].libexec
    ENV["SIFDECODE"] = libexec
    ENV["MYARCH"] = "#{machine}.#{arch}.#{compiler}"
    ENV["MASTSIF"] = "#{libexec}/sif"

    cd testpath do
      system "sifdecoder", "#{libexec}/sif/ROSENBR.SIF"
    end
    ohai "Test results are in ~/Library/Logs/Homebrew/sifdecode."
  end
end
