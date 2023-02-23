# gitmaster
OneClick Installer Creator for https://github.com/ZOSOpenTools/gitport

## Installation

Git clone this repository.

Then execute the setupall.sh (e.g. sh setupall.sh)

This will download (using curl) pax.Z files for bash, git, ncurses, and perl.
These will then be un/de-paxed and processed to create gitinstaller.sh.
This gitinstaller.sh will have all the packages embedded within it and will 'self-extract' them from the script :)

## Pre-Requisite (curl)

If you do not have curl installed then use these commands to get it:

    curl -k -L -s https://github.com/ZOSOpenTools/perlport/releases/download/perlport_531/perl5-blead.20230210_213003.zos.pax.Z --output perl.pax.Z
    pax -rf perl.pax.Z
    cd /path/to/where/it/unpaxed
    . ./.env

## Workings...
This will generate a oneclick installer for git from ZOT. You need some space to build the installer, a zFS with 864000 blocks would do.

*Make sure* to have enough space for running the resulting gitinstaller.sh

## Versions

Currently embedded versions

* https://github.com/ZOSOpenTools/bashport/releases/download/bashport_605/bash-5.2.20230218_210446.zos.pax.Z 
* https://github.com/ZOSOpenTools/perlport/releases/download/perlport_531/perl5-blead.20230210_213003.zos.pax.Z 
* https://github.com/ZOSOpenTools/ncursesport/releases/download/ncursesport_618/ncurses-6.3.20230219_035409.zos.pax.Z
* https://github.com/ZOSOpenTools/lessport/releases/download/lessport_549/less-608.20230215_172444.zos.pax.Z
* https://github.com/ZOSOpenTools/gitport/releases/download/gitport_519/git-2.39.1.20230210_171810.zos.pax.Z 
