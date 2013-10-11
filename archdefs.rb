require 'formula'

# CCPForge requires that svn checkouts be done with --username anonymous.
# This should be available in Homebrew by default in the near future.

class AnonymousSubversionDownloadStrategy < SubversionDownloadStrategy
  def fetch_repo target, url, revision=nil, ignore_externals=false
    # Use "svn up" when the repository already exists locally.
    # This saves on bandwidth and will have a similar effect to verifying the
    # cache as it will make any changes to get the right revision.
    svncommand = target.directory? ? 'up' : 'checkout'
    args = ['svn', svncommand]
    args << '--username'
    args << 'anonymous'
    # SVN shipped with XCode 3.1.4 can't force a checkout.
    args << '--force' unless MacOS.version == :leopard
    args << url unless target.directory?
    args << target
    args << '-r' << revision if revision
    args << '--ignore-externals' if ignore_externals
    quiet_safe_system(*args)
  end
end

class Archdefs < Formula
  homepage 'http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki'
  head 'http://ccpforge.cse.rl.ac.uk/svn/cutest/archdefs/trunk', :using => AnonymousSubversionDownloadStrategy

  keg_only 'This formula only installs data files'

  def install
    bin.install Dir['bin/*']
    prefix.install Dir['ccompiler*'], Dir['compiler*'], Dir['system*']
    Pathname.new("#{prefix}/archdefs.bashrc").write <<-EOF.undent
      export ARCHDEFS=#{prefix}
    EOF
  end

  def caveats; <<-EOS.undent
    In your ~/.bashrc, add the line
    . #{prefix}/archdefs.bashrc
    EOS
  end
end
