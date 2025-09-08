# Homebrew's [CUTEst](https://github.com/ralna/CUTEst) Tap

[![brew test-bot](https://github.com/optimizers/homebrew-cutest/actions/workflows/tests.yml/badge.svg)](https://github.com/optimizers/homebrew-cutest/actions/workflows/tests.yml)

## For the Impatient

    brew tap optimizers/cutest
    brew install cutest
    brew install mastsif  # If you want the whole SIF collection.
    for f in "mastsif" "sifdecode" "cutest"; do \
      echo ". $(brew --prefix $f)/$f.bashrc" >> ~/.bashrc; \
    done

It is also possible to build the Matlab interface to CUTEst:

    brew install cutest --with-matlab

## What's This?

This [Homebrew](http://brew.sh) [tap](https://github.com/mxcl/homebrew/wiki/brew-tap) allows you to install [CUTEst](https://github.com/ralna/CUTEst) and related tools inside the control of Homebrew. This has advantages and disadvantages.

### Advantages

* One simple command to install each tool: `brew install tool`
* Precompiled binaries are available for Linux and macOS
* No need to tweak your `PATH`, `LD_LIBRARY_PATH`, `MANPATH` and so forth
* `libsifdecode`, `libcutest` and `libcutest_single` are available directly in `/usr/local/lib` so linking them in is a simple matter of adding `-lsifdecode`, `-lcutest` or `-lcutest_single`
* installation of a Matlab-friendly compiler is taken in charge.

### Disadvantages

* Only OSX and Linux are supported
* Only one architecture of SIFDecode and CUTEst can be built
* Cannot easily select esoteric compilers

## Installing

Brew taps are repositories of Homebrew formulae. In order to use this one, you first need to tap it:

    brew tap optimizers/cutest

Now we can install CUTEst and, at your option, the entire SIF collection:

    brew install cutest [--with-matlab] [--without-single] [--with-pgi]
    brew install mastsif  # If you want the whole SIF collection.
    brew install maros_mezaros #If you want the Maros-Mezaros collection
    brew install netlib #If you want the NETLIB LP collection

The `mastsif`, `maros_mezaros` and `netlib` formulae only install data files.

The last thing to do is to add all the requisite environment variables to our `~/.bashrc`. Each package provides a mini `bashrc` that contains the relevant definitions and can be sourced. They can all be sourced in one command:

    for f in "mastsif" "sifdecode" "cutest"; do \
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

Every time the formulae are updated, `brew update` will let you know. You may then reinstall them using `brew reinstall sifdecode`, etc.

## Development Builds

If you so desire, you may build directly from the latest sources in the Subversion repositories. All that is required is to pass the `--HEAD` option to each build command, e.g., `brew install sifdecode --HEAD`.

## Partial Installs

You can install only `sifdecode` or only `mastsif` using the
command

    brew install <formula>

Enjoy!

