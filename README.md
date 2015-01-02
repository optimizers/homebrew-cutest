# Homebrew's [CUTEst](http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki) Tap

[![Build Status](https://travis-ci.org/dpo/homebrew-cutest.svg?branch=master)](https://travis-ci.org/dpo/homebrew-cutest)

## For the Impatient

    brew tap dpo/cutest
    brew tap homebrew/versions   # If you want Matlab support.
    brew install cutest --HEAD [--with-matlab]
    brew install mastsif --HEAD  # If you want the whole SIF collection.
    for f in "archdefs" "mastsif" "sifdecode" "cutest"; do \
      echo ". $(brew --prefix $f)/$f.bashrc" >> ~/.bashrc; \
    done

## What's This?

This [Homebrew](http://brew.sh) [tap](https://github.com/mxcl/homebrew/wiki/brew-tap) allows you to install [CUTEst](http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki) and related tools inside the control of Homebrew. This has advantages and disadvantages.

### Advantages

* One simple command to install each tool: `brew install tool --HEAD`
* No need to tweak your `PATH`, `LD_LIBRARY_PATH`, `MANPATH` and so forth
* `libsifdecode`, `libcutest` and `libcutest_single` are available directly in `/usr/local/lib` so linking them in is a simple matter of adding `-lsifdecode`, `-lcutest` or `-lcutest_single`
* installation of a Matlab-friendly compiler is taken in charge.

### Disadvantages

* Only one architecture of SIFDecode and CUTEst can be built
* Cannot easily select esoteric compilers
* Cannot upgrade using usual commands (for now).

## Installing

Brew taps are repositories of Homebrew formulae. In order to use this one, you first need to tap it:

    brew tap dpo/cutest

If you will require Matlab support in CUTEst, you also need to tap [homebrew/versions](https://github.com/Homebrew/homebrew-versions), a repository that gives access to gcc and gfortran 4.3 as those are [the only ones supported by the Mathworks on OSX](http://www.mathworks.com/support/compilers/R2013b/index.html?sec=maci64):

    brew tap homebrew/versions

Now we can install CUTEst and, at your option, the entire SIF collection:

    brew install cutest --HEAD [--with-matlab]
    brew install mastsif --HEAD  # If you want the whole SIF collection.

The last thing to do is to add all the requisite environment variables to our `~/.bashrc`. Each package provides a mini `bashrc` that contains the relevant definitions and can be sourced. They can all be sourced in one command:

    for f in "archdefs" "mastsif" "sifdecode" "cutest"; do \
      echo ". $(brew --prefix $f)/$f.bashrc" >> ~/.bashrc; \
    done

Note: it might be that you have to add the above to your `~/.profile` instead
of your `~/.bashrc` if you are using Yosemite.

If you installed CUTEst with Matlab support, you also need to define an environment variable pointing to your local Matlab installation, e.g.,

    export MYMATLAB=/Applications/Matlab/MATLAB_R2012a.app

## Testing

You can check that everything works as intended using:

    brew test sifdecode
    brew test cutest

## Updating

Every time the formulae are updated, `brew update` will let you know. You may then reinstall them using `brew reinstall sifdecode --HEAD`, etc. The software will not be automatically upgraded because the formulae are currently "head only", meaning that they pull directly from the subversion repository instead of fetching a released distribution (e.g., `sifdecode-1.0.tar.gz`). This is only temporary as we are planning to release distributions in the near future. Once that is done, updating will be easier.

## Partial Installs

You can install only `archdefs`, only `sifdecode` or only `mastsif` using the
command

    brew install <formula> --HEAD

Because `archdefs` is a prerequisite of `sifdecode`, running `brew install
sifdecode --HEAD` will also install `archdefs`.

Enjoy!

