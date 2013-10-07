# Homebrew's [CUTEst](http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki) Tap

## For the Impatient

    brew tap dpo/cutest
    brew install archdefs --HEAD
    brew install sifdecode --HEAD
    brew tap homebrew/versions   # If you want Matlab support
    brew install cutest --HEAD [--with-matlab]
    brew install mastsif --HEAD  # If you want the whole SIF collection.
    for f in "archdefs" "mastsif" "sifdecode" "cutest"; do \
      echo ". $(brew --prefix $f)/$f.bashrc >> ~/.bashrc"; \
    done

## What's This?

This [Homebrew](http://brew.sh) [tap](https://github.com/mxcl/homebrew/wiki/brew-tap) allows you to install [CUTEst](http://ccpforge.cse.rl.ac.uk/gf/project/cutest/wiki) and related tools inside the control of Homebrew. This has advantages and disadvantages.

### Advantages

* One simple command to install each tool: `brew install tool --HEAD`
* No need to tweak your `PATH`, `LD_LIBRARY_PATH`, `MANPATH` and so forth
*

### Disadvantages

* Only one architecture of SIFDecode and CUTEst can be built
* Cannot upgrade using usual commands

## Installing

Brew taps are repositories of Homebrew formulae. In order to use this one, you first need to tap it:

    brew tap dpo/cutest

If you will require Matlab support in CUTEst, you also need to tap a repository that gives access to gcc and gfortran 4.3 as those are the only ones supported by the Mathworks on OSX:

    brew tap homebrew/versions

Now we can install the formulae in order:

    brew install archdefs --HEAD
    brew install sifdecode --HEAD
    brew install cutest --HEAD [--with-matlab]
    brew install mastsif --HEAD  # If you want the whole SIF collection.

The last thing to do is to add all the requisite environment variables to our `~/.bashrc`. Each package provides a mini `bashrc` that contains the relevant definitions and can be sourced. They can all be sourced in one command:

    for f in "archdefs" "mastsif" "sifdecode" "cutest"; do \
      echo ". $(brew --prefix $f)/$f.bashrc >> ~/.bashrc"; \
    done

## Testing

You can check that everything works as intended using:

    brew test sifdecode
    brew test cutest

Enjoy!
