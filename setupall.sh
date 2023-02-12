#!/bin/sh

# Setting up ZOSOpenTools the way it should be :)
# wizardofzos 2023

# Get bash, perl, ncurses and git
echo "Getting bash"
curl -k -L -s https://github.com/ZOSOpenTools/bashport/releases/download/bashport_518/bash-5.2.20230210_170433.zos.pax.Z --output bash.pax.Z 
echo "Getting perl"
curl -k -L -s https://github.com/ZOSOpenTools/perlport/releases/download/perlport_531/perl5-blead.20230210_213003.zos.pax.Z --output perl.pax.Z
echo "Getting ncurses"
curl -k -L -s https://github.com/ZOSOpenTools/ncursesport/releases/download/ncursesport_521/ncurses-6.3.20230210_180151.zos.pax.Z --output ncurses.pax.Z
echo "Getting git"
curl -k -L -s https://github.com/ZOSOpenTools/gitport/releases/download/gitport_519/git-2.39.1.20230210_171810.zos.pax.Z --output git.pax.Z 


# get all the stuff in the right place.....delete targets first
echo "Un/de paxing...."
# clear previous muck
rm -rf gitzot
mkdir gitzot


# Un(de?)pax bash: Get directory it will extract to, and rename/move to bash
echo "Bash..."
pax -v -f bash.pax.Z > tmpfile
bashpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf bash.pax.Z
mv $bashpath gitzot/bash
rm tmpfile

# Un(de?)pax perl: Get directory it will extract to, and rename/move to perl
echo "Perl..."
pax -v -f perl.pax.Z > tmpfile
perlpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf perl.pax.Z
mv $perlpath gitzot/perl
rm tmpfile

# Un(de?)pax ncurses: Get directory it will extract to, and rename/move to ncurses
echo "Ncurses..."
pax -v -f ncurses.pax.Z > tmpfile
ncursespath=`head -n 1 tmpfile | cut -c55-100`
pax -rf ncurses.pax.Z
mv $ncursespath gitzot/ncurses
rm tmpfile

# Un(de?)pax git: Get directory it will extract to, and rename/move to git
echo "Git..."
pax -v -f git.pax.Z > tmpfile
gitpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf git.pax.Z
mv $gitpath gitzot/git
rm tmpfile



# Use code from to zdopack craft a proper receiver (that takes care of all the .env stuff :) 
srcuss=`pwd`/gitzot
workdir=".pack-work-dir"
echo "Paxing your USS folder to $workdir/paxfile"
pax -o saveext -s ",$srcuss,distfolder," -wzvf  $workdir/file.pax $srcuss
echo "Mime encoding it to $workdir/mimefile"
uuencode -m $workdir/file.pax $workdir/mimefile > $workdir/mimefile
echo "Creating the receiver"
cat template.sh $workdir/mimefile > gitinstaller.sh

