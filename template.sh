#!/bin/bash

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  clear
else
  echo ""
  echo "FSOC1801 : NON SSH (OMVS) SESSION DETECTED"
  echo "           PRESS ENTER TO CONTINUE"
  read fsoc
  echo ""
fi

echo "======================================================================";
echo "==      =============  =====  ============EPLS Git Installer for z/OS=";
echo "=   ==   ============   ===   ========================================";
echo "=  ====  =======  ===  =   =  =================  =====================";
echo "=  ========  ==    ==  == ==  ===   ====   ===    ===   ===  =   =====";
echo "=  =============  ===  =====  ==  =  ==  =  ===  ===  =  ==    =  ====";
echo "=  ===   ==  ===  ===  =====  =====  ===  =====  ===     ==  =========";
echo "=  ====  ==  ===  ===  =====  ===    ====  ====  ===  =====  =========";
echo "=   ==   ==  ===  ===  =====  ==  =  ==  =  ===  ===  =  ==  =========";
echo "==      ===  ===   ==  =====  ===    ===   ====   ===   ===  =========";
echo "======================================================================";
echo "                              https://github.com/wizardofzos/gitmaster";
echo ""
echo ""

# Find our PACKED DATA
ARCHIVE=`awk '/^__ZDOPACK_DATA_BELOW__/ {print NR + 1; exit 0; }' $0`

# Start this Golberg Machine...

echo "This will install git (and prereqs) from https://github.com/ZOSOpenTools"
echo "without the need for a connection to github from your Mainframe."
echo "All files will be owned by $LOGNAME (logon to another user if need be)."
echo "Make sure you have at least 200MB free space in the target location."
echo ""
echo "Press [Enter] to specify installation destination"
echo "(or Q to quit now (but why would you?)\c"
read goon
if [[ ! -z "$goon" ]]; then 
  echo ""
  echo "Sorry to see you leave..."
  exit
fi
echo "Folder to install git (and prereqs) to (no trailing slash): \c"
read dest

echo "Grabbing mime-data from this shell script,might take a while, \
go grab a coffee, you've deserved it."
tail -n+$ARCHIVE $0 > mimefile
echo "Decoding it to pax file"
echo "(how's that coffee?)"
uudecode -o file.pax mimefile
echo "Deleting intermediate mimefile"
rm mimefile # we no need that no more...
echo "Un(de) paxing it to file.pax"
pax -rvf file.pax
echo "Deleting pax file"
rm file.pax

# Now we can work with the new folder :)
mkdir -p $dest 
# copy all to that location

echo "Copying to destination folder ($dest)"
cp -R distfolder/* $dest/
rm -rf distfolder   # maybe make this a move :)

# Tools are now "installed" to that location, better set them up...
echo "Now running the .env installers from the ZOSOpenTools..."
# First .env from bash...
cd $dest/bash && . ./.env 

# Then Perl
cd $dest/perl && . ./.env

# Ncurses
cd $dest/ncurses && . ./.env

# Less
cd $dest/less && . ./.env

# And finally git (CEE3501S The module CXXRT64 was not found. might occur?)
cd $dest/git && . ./.env

# Now we have all in EXPORTed variables we need.... 
# better create the ENVFILE with parts we want...
echo "Creating your envfiles"
env=$dest/envfile
rm -f $env
echo "#" >> $env
echo "# gitmaster static envfile" >> $env
echo "#" >> $env
echo "# To use this git installtion add the contents of this file to" >> $env 
echo "# the end of your .profile, or source via '. $dest/envfile'." >> $env
echo "#" >> $env
echo "# wizardofzos, 2023" >> $env 
echo "#" >> $env
for var in BASH_HOME GIT_EXEC_PATH GIT_HOME GIT_PAGER \
GIT_TEMPLATE_DIR NCURSES_HOME  \
PERL5LIB PERL5_HOME TERM _BPXK_AUTOCVT _CEE_RUNOPTS \
 _TAG_REDIR_ERR _TAG_REDIR_IN  _TAG_REDIR_OUT
do
    l=$(export | grep ^$var= | cut -d= -f2)
    echo "export $var=$l" >> $env
done
echo "export GIT_SSL_CAINFO=$dest/cacert.pem" >> $env

# Terminfo not set by ncurses installer?
echo "export TERMINFO=$dest/ncurses/share/terminfo" >> $env

# Get the stuff in for LIBPATH, MANPATH and PATH, but(!) keep old stuff as $PATH
pathvar='$PATH'
libpathvar='$LIBPATH'
manpathvar='$MANPATH'
echo "export PATH=$dest/git/bin:$dest/less/bin:$dest/ncurses/bin:$dest/perl/bin:\
$dest/bash/bin:$pathvar" >> $env 
echo "export LIBPATH=$dest/ncurses/lib:$dest/perl/lib/perl5/5.37.9/os390/CORE:\
$dest/perl/lib:$libpathvar" >> $env 
echo "export MANPATH=$dest/less/share/man:$dest/ncurses/share/man:\
$dest/bash/share/man:$manpathvar" >> $env

# Make the dynamic envfile
dynenv=$dest/dynenv
echo "#" >> $dynenv
echo "# gitmaster dynamic envfile" >> $dynenv
echo "#" >> $dynenv
echo "# You can use this envfile after you've moved the gitmaster" >> $dynenv 
echo "# installation to a new location. You then have to be in the">> $dynenv
echo "# new location amd source it. (e.g. cd /path/to/new/loc && . ./dynenv)">> $dynenv
echo "#" >> $dynenv
echo "# wizardofzos, 2023" >> $dynenv 
echo "#" >> $dynenv
pwdstring='$PWD'
tail -n+9 $env > tmpenv
sed "s|${dest}|$pwdstring|g" tmpenv >> $dynenv
rm tmpenv 

echo "                                                            ";
echo "'########:'##::: ##:'##::::'##:'########:'####:'##:::::::'########:";
echo " ##.....:: ###:: ##: ##:::: ##: ##.....::. ##:: ##::::::: ##.....::";
echo " ##::::::: ####: ##: ##:::: ##: ##:::::::: ##:: ##::::::: ##:::::::";
echo " ######::: ## ## ##: ##:::: ##: ######:::: ##:: ##::::::: ######:::";
echo " ##...:::: ##. ####:. ##:: ##:: ##...::::: ##:: ##::::::: ##...::::";
echo " ##::::::: ##:. ###::. ## ##::: ##:::::::: ##:: ##::::::: ##:::::::";
echo " ########: ##::. ##:::. ###:::: ##:::::::'####: ########: ########:";
echo "........::..::::..:::::...:::::..::::::::....::........::........::";                      
echo ""
echo "Environment file created at $dest/envfile, contents follows"
cat $dest/envfile
echo ""
echo ""
echo "You can source $dest/envfile and bash/perl/ncurses/less/git should work!"
echo ""
echo "If you want a 'dynamic' envfile (that can be sourced from install-folder)"
echo "you need to 'cd <new location of $dest> && . ./dynenv"

exit 0

__ZDOPACK_DATA_BELOW__