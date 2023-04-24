#!/bin/sh

# Setting up ZOSOpenTools the way it should be :)
# wizardofzos 2023

# clear previous muck
echo "Cleanup previous run..."
rm -rf gitzot
mkdir gitzot
rm -rf .pack-work-dir
mkdir .pack-work-dir


# URL's
GITPAX=https://github.com/ZOSOpenTools/gitport/releases/download/Releaseline_gitport_918/git-2.39.2.20230417_063629.zos.pax.Z
BASHPAX=https://github.com/ZOSOpenTools/bashport/releases/download/Releaseline_bashport_906/bash-5.2.15.20230416_201300.zos.pax.Z
PERLPAX=https://github.com/ZOSOpenTools/perlport/releases/download/Releaseline_perlport_922/perl5-blead.20230417_074329.zos.pax.Z
NCURSESPAX=https://github.com/ZOSOpenTools/ncursesport/releases/download/Releaseline_ncursesport_923/ncurses-6.3.20230417_110611.zos.pax.Z
LESSPAX=https://github.com/ZOSOpenTools/lessport/releases/download/Releaseline_lessport_911/less-608.20230416_234518.zos.pax.Z

# Get bash, perl, ncurses and git
echo "Getting bash"
curl -k -L -s $BASHPAX --output bash.pax.Z 
echo " - unpaxing.."
pax -v -f bash.pax.Z > tmpfile
bashpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf bash.pax.Z
rm bash.pax.Z
echo " - moving into place"
mv $bashpath gitzot/bash
rm tmpfile

echo "Getting perl"
curl -k -L -s $PERLPAX --output perl.pax.Z
echo " - unpaxing.."
pax -v -f perl.pax.Z > tmpfile
perlpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf perl.pax.Z
rm perl.pax.Z
echo " - moving into place"
mv $perlpath gitzot/perl
rm tmpfile

echo "Getting ncurses"
curl -k -L -s $NCURSESPAX --output ncurses.pax.Z
echo " - unpaxing.."
pax -v -f ncurses.pax.Z > tmpfile
ncursespath=`head -n 1 tmpfile | cut -c55-100`
pax -rf ncurses.pax.Z
rm ncurses.pax.Z
echo " - moving into place"
mv $ncursespath gitzot/ncurses
rm tmpfile

echo "Getting less"  
curl -k -L -s $LESSPAX --output less.pax.Z 
echo " - unpaxing.."
pax -v -f less.pax.Z > tmpfile
lesspath=`head -n 1 tmpfile | cut -c55-100`
pax -rf less.pax.Z
rm less.pax.Z
echo " - moving into place"
mv $lesspath gitzot/less
rm tmpfile

echo "Getting git"
curl -k -L -s $GITPAX --output git.pax.Z 
echo " - unpaxing.."
pax -v -f git.pax.Z > tmpfile
gitpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf git.pax.Z
rm git.pax.Z
echo " - moving into place"
mv $gitpath gitzot/git
rm tmpfile

echo "Getting CA Certs (from https://curl.se/ca/cacert.pem)"
pemloc=`pwd`/gitzot/cacert.pem  
curl -k -L -s https://curl.se/ca/cacert.pem --output $pemloc

echo "All done, packaging with zdopack"
# Use code from to zdopack craft a proper receiver (that takes care of all the .env stuff :) 
srcuss=`pwd`/gitzot
workdir=".pack-work-dir"
echo "Paxing your USS folder to $workdir/paxfile"
pax -o saveext -s ",$srcuss,distfolder," -wzvf  $workdir/file.pax $srcuss
echo "Mime encoding it to $workdir/mimefile"
uuencode -m $workdir/file.pax $workdir/mimefile > $workdir/mimefile
echo "Creating gitmaster.sh"
cat template.sh $workdir/mimefile > gitmaster.sh

