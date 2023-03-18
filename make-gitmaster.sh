#!/bin/sh

# Setting up ZOSOpenTools the way it should be :)
# wizardofzos 2023

# clear previous muck
echo "Cleanup previous run..."
rm -rf gitzot
mkdir gitzot
rm -rf .pack-work-dir
mkdir .pack-work-dir


# Get bash, perl, ncurses and git
echo "Getting bash"
curl -k -L -s https://github.com/ZOSOpenTools/bashport/releases/download/bashport_646/bash-5.2.20230226_190557.zos.pax.Z --output bash.pax.Z 
echo " - unpaxing.."
pax -v -f bash.pax.Z > tmpfile
bashpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf bash.pax.Z
rm bash.pax.Z
echo " - moving into place"
mv $bashpath gitzot/bash
rm tmpfile

echo "Getting perl"
curl -k -L -s https://github.com/ZOSOpenTools/perlport/releases/download/perlport_761/perl5-blead.20230316_225400.zos.pax.Z --output perl.pax.Z
echo " - unpaxing.."
pax -v -f perl.pax.Z > tmpfile
perlpath=`head -n 1 tmpfile | cut -c55-100`
pax -rf perl.pax.Z
rm perl.pax.Z
echo " - moving into place"
mv $perlpath gitzot/perl
rm tmpfile

echo "Getting ncurses"
curl -k -L -s https://github.com/ZOSOpenTools/ncursesport/releases/download/ncursesport_682/ncurses-6.3.20230306_010811.zos.pax.Z --output ncurses.pax.Z
echo " - unpaxing.."
pax -v -f ncurses.pax.Z > tmpfile
ncursespath=`head -n 1 tmpfile | cut -c55-100`
pax -rf ncurses.pax.Z
rm ncurses.pax.Z
echo " - moving into place"
mv $ncursespath gitzot/ncurses
rm tmpfile

echo "Getting less"  
curl -k -L -s https://github.com/ZOSOpenTools/lessport/releases/download/lessport_690/less-608.20230306_103304.zos.pax.Z --output less.pax.Z 
echo " - unpaxing.."
pax -v -f less.pax.Z > tmpfile
lesspath=`head -n 1 tmpfile | cut -c55-100`
pax -rf less.pax.Z
rm less.pax.Z
echo " - moving into place"
mv $lesspath gitzot/less
rm tmpfile

echo "Getting git"
curl -k -L -s https://github.com/ZOSOpenTools/gitport/releases/download/gitport_748/git-2.39.2.20230313_123033.zos.pax.Z --output git.pax.Z 
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

