# oneclickzotgit
OneClick Installer Creator for https://github.com/ZOSOpenTools/gitport

## Installation

Git clone this repository.

Then execute the setupall.sh (e.g. sh setupall.sh)

This will download (using curl) pax.Z files for bash, git, ncurses, and perl.
These will then be un/de-paxed and processed to create gitinstaller.sh

## Workings...
This will generate a oneclick installer for git from ZOT.
*Make* sure to have enough space for running the resulting gitinstaller.sh

## Versions

Currently embedded versions

https://github.com/ZOSOpenTools/bashport/releases/download/bashport_518/bash-5.2.20230210_170433.zos.pax.Z 
https://github.com/ZOSOpenTools/perlport/releases/download/perlport_531/perl5-blead.20230210_213003.zos.pax.Z 
https://github.com/ZOSOpenTools/ncursesport/releases/download/ncursesport_521/ncurses-6.3.20230210_180151.zos.pax.Z
https://github.com/ZOSOpenTools/gitport/releases/download/gitport_519/git-2.39.1.20230210_171810.zos.pax.Z 
