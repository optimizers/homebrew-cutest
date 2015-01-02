# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system *args
    super *args + ['--username', 'anonymous']
  end
end

class Mastsif < Formula
  homepage 'http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki'
  head 'http://ccpforge.cse.rl.ac.uk/svn/cutest/sif/trunk', :using => AnonymousSubversionDownloadStrategy

  keg_only 'This formula only installs data files'

  def install
    prefix.install Dir['*']
    Pathname.new("#{prefix}/mastsif.bashrc").write <<-EOF.undent
      export MASTSIF=#{prefix}
    EOF
  end

  def caveats; <<-EOS.undent
    In your ~/.bashrc, add the line
    . #{prefix}/mastsif.bashrc
    EOS
  end
end
