# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super(*args + ["--username", "anonymous"])
  end
end

class Sifdecode < Formula
  homepage "http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki"
  head "http://ccpforge.cse.rl.ac.uk/svn/cutest/sifdecode/trunk", :using => AnonymousSubversionDownloadStrategy

  depends_on "dpo/cutest/archdefs" => :build
  depends_on :fortran
  env :std

  def install
    ENV.deparallelize

    machine, mac = (MacOS.prefer_64_bit?) ? %w(mac64 13) : %w(mac 12)
    Pathname.new("osx.input").write <<-EOF.undent
      #{mac}
      2
      nny
    EOF

    ENV["ARCHDEFS"] = Formula["archdefs"].libexec
    system "./install_sifdecode < osx.input"

    # We only want certain links in /usr/local/bin.
    libexec.install Dir["*"]
    %w(sifdecoder classall select).each do |f|
      bin.install_symlink "#{libexec}/bin/#{f}"
    end

    man1.install_symlink Dir["#{libexec}/man/man1/*.1"]
    doc.install_symlink Dir["#{libexec}/doc/*"]
    lib.install_symlink Dir["#{libexec}/objects/#{machine}.osx.gfo/double/*.a"]

    (prefix / "sifdecode.bashrc").write <<-EOF.undent
      export SIFDECODE=#{libexec}
      export MYARCH=#{machine}.osx.gfo
    EOF
    (prefix / "sifdecode.machine").write(machine)
  end

  test do
    machine = File.read(prefix / "sifdecode.machine")
    ENV["ARCHDEFS"] = Formula["archdefs"].libexec
    ENV["SIFDECODE"] = libexec
    ENV["MYARCH"] = "#{machine}.osx.gfo"
    ENV["MASTSIF"] = "#{libexec}/sif"

    system "sifdecoder #{libexec}/sif/ROSENBR.SIF"
    ohai "Test results are in ~/Library/Logs/Homebrew/sifdecode."
  end

  def caveats; <<-EOS.undent
    In your ~/.bashrc, add the line
    . #{prefix}/sifdecode.bashrc
    EOS
  end
end
