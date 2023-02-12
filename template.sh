#!/bin/bash
echo ""
echo "One Click Git Installer"
echo " - all you need is a bit of patience..."

# Find our PACKED DATA
ARCHIVE=`awk '/^__ZDOPACK_DATA_BELOW__/ {print NR + 1; exit 0; }' $0`

# Start this Golberg Machine...

echo "Grabbing mime-data from shell script."
tail -n+$ARCHIVE $0 > mimefile
echo "Decoding it to pax file"
uudecode -o file.pax mimefile
echo "Deleting intermediate mimefile"
rm mimefile # we no need that no more...
echo "Un(de) paxing it to file.pax"
pax -rvf file.pax
echo "Deleting pax file"
rm file.pax

# Now we can work with the new folder :)
echo "Folder to install git (and prereqs) to (no trailing slash): \c"
read dest
mkdir -p $dest 
# copy all to that location

echo "Copying to destsination folder"
cp -R distfolder/* $dest/
rm -rf distfolder   # maybe make this a move :)

# Tools are now "installed" to that location, better set them up...

# First .env from bash...
cd $dest/bash && . ./.env 

# Then Perl
cd $dest/perl && . ./.env

# Ncurses
cd $dest/ncurses && . ./.env

# And finally git (CEE3501S The module CXXRT64 was not found. might occur?)
cd $dest/git && . ./.env

# Now we have all in EXPORTed variables we need.... better create the ENVFILE with parts we want...
env=$dest/envfile
rm -f $env
echo "#" >> $env
echo "# Environment file for zotgit (and prereqs)" >> $env
echo "#" >> $env
echo "# To use this git installtion add the contents of this file to" >> $env 
echo "# the end of your .profile, or source via '. $dest/envfile'." >> $env
echo "#" >> $env
echo "# wizardofzos, 2023" > $env 
echo "#" > $env
for var in BASH_HOME CURL_CA_BUNDLE GIT_EXEC_PATH GIT_HOME GIT_PAGER GIT_SSL_CAINFO GIT_TEMPLATE_DIR LIBPATH MANPATH NCURSES_HOME PATH PARL5LIB PERL5_HOME TERM TERMINFO _BPXK_AUTOCVT _CC_RUNOPTS _CEE_RUNOPTS _CXX_RUNOPTS _TAG_REDIR_ERR _TAG_REDIR_IN  _TAG_REDIR_OUT
do
    l=$(export | grep ^$var= | cut -d= -f2)
    echo "export $var=$l" >> $env
done

echo "All done? Source $dest/envfile and try 'git' :)"

exit 0

__ZDOPACK_DATA_BELOW__
