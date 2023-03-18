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

# Usage overview

After downloading (or building) the gitinstaller.sh and uploading it to you Mainframe yo umust run gitinstaller.sh like so:

    >sh gitinstaller.sh
    terminals database is inaccessible
    ======================================================================
    ==      =============  =====  ============EPLS Git Installer for z/OS=
    =   ==   ============   ===   ========================================
    =  ====  =======  ===  =   =  =================  =====================
    =  ========  ==    ==  == ==  ===   ====   ===    ===   ===  =   =====
    =  =============  ===  =====  ==  =  ==  =  ===  ===  =  ==    =  ====
    =  ===   ==  ===  ===  =====  =====  ===  =====  ===     ==  =========
    =  ====  ==  ===  ===  =====  ===    ====  ====  ===  =====  =========
    =   ==   ==  ===  ===  =====  ==  =  ==  =  ===  ===  =  ==  =========
    ==      ===  ===   ==  =====  ===    ===   ====   ===   ===  =========
    ======================================================================
                                https://github.com/wizardofzos/gitmaster


    This will install git (and prereqs) from https://github.com/ZOSOpenTools
    without the need for a connection to github from your Mainframe.
    All files will be owned by IBMUSER (logon to another user if need be).
    Make sure you have at least 200MB free space in the target location.

    Packages and version that will be installed:

    - bash-5.2.20230226_190557
    - perl5-blead.20230316_225400
    - ncurses-6.3.20230306_010811
    - less-608.20230306_103304
    - git-2.39.2.20230313_123033

    Press [Enter] to specify installation destination
    (or Q to quit now (but why would you?)

You can then CTRL-C or press Q followed by ENTER to stop the installation
When continuing (just press ENTER) you're asked where to install the bundle.
This example uses /prj/git005. Make sure this folder (and the zfs containing it) has
enouth space (500 CYLS should definately do it)

    Folder to install git (and prereqs) to (no trailing slash): /prj/git005
    Grabbing mime-data from shell script.
    This might take a while, go grab a coffee, you've deserved it.
    ..
    .. time passes
    ..
    Decoding it to pax file
    ..
    distfolder/ncurses/share/man/man3/curs_printw.3x
    distfolder/ncurses/share/man/man3/curs_addchstr.3x
    distfolder/ncurses/share/man/man3/curs_addwstr.3x
    distfolder/ncurses/share/man/man3/curs_bkgd.3x
    ..
    distfolder/cacert.pem
    Deleting pax file
    Copying to destination folder
    Setting up bash...
    Setup completed.
    Setting up perl5...
    Setup completed.
    Setting up ncurses...
    Setup completed.
    Setting up less...
    Setup completed.
    Warning: you are using git in an insecure way, consider unsetting GIT_SSL_NO_VERIFY or setting http.sslVerify to true.
    Warning: you are using git in an insecure way, consider unsetting GIT_SSL_NO_VERIFY or setting http.sslVerify to true.
    Setting up git...
    Setup completed.

After the installation scripts from the various ZOSOpenTools products (still need to tackle that GIT INSECURE warning) you'll get an overview of the modified environment variables, aswell as a pointer to the 'envfile' containing these settings.

    '########:'##::: ##:'##::::'##:'########:'####:'##:::::::'########:
    ##.....:: ###:: ##: ##:::: ##: ##.....::. ##:: ##::::::: ##.....::
    ##::::::: ####: ##: ##:::: ##: ##:::::::: ##:: ##::::::: ##:::::::
    ######::: ## ## ##: ##:::: ##: ######:::: ##:: ##::::::: ######:::
    ##...:::: ##. ####:. ##:: ##:: ##...::::: ##:: ##::::::: ##...::::
    ##::::::: ##:. ###::. ## ##::: ##:::::::: ##:: ##::::::: ##:::::::
    ########: ##::. ##:::. ###:::: ##:::::::'####: ########: ########:
    ........::..::::..:::::...:::::..::::::::....::........::........::

    BASH_HOME="/prj/git005/bash"
    GIT_EXEC_PATH="/prj/git005/git/libexec/git-core/"
    GIT_HOME="/prj/git005/git"
    GIT_PAGER="less"
    GIT_TEMPLATE_DIR="/prj/git005/git/share/git-core/templates"
    LIBPATH="/prj/git005/ncurses/lib:/prj/git005/perl/lib/perl5/5.37.9/os390/CORE:/prj/git005/perl/lib:/prj/git003/ncurses/lib:/prj/git003/perl/lib/perl5/5.37.9/os390/CORE:/prj/git003/perl/lib:/prj/git002/ncurses/lib:/prj/git002/perl/lib/perl5/5.37.9/os390/CORE:/prj/git002/perl/lib:/zdo/conda/envs/ispfgit/lib/perl5/5.24.0/os390/CORE:/usr/lpp/db2c10/jdbc/lib:/lib:/usr/lib:/usr/lpp/IBM/zoautil/lib:."
    MANPATH="/prj/git005/less/share/man:/prj/git005/ncurses/share/man:/prj/git005/bash/share/man:/prj/git003/less/share/man:/prj/git003/ncurses/share/man:/prj/git003/bash/share/man:/prj/git002/less/share/man:/prj/git002/ncurses/share/man:/prj/git002/bash/share/man:/usr/man/%L:/zdo/conda/envs/ispfgit/man"
    NCURSES_HOME="/prj/git005/ncurses"
    PATH="/prj/git005/git/bin:/prj/git005/less/bin:/prj/git005/ncurses/bin:/prj/git005/perl/bin:/prj/git005/bash/bin:/prj/git003/git/bin:/prj/git003/less/bin:/prj/git003/ncurses/bin:/prj/git003/perl/bin:/prj/git003/bash/bin:/prj/git002/git/bin:/prj/git002/less/bin:/prj/git002/ncurses/bin:/prj/git002/perl/bin:/prj/git002/bash/bin:/zdo/conda/envs/ispfgit/bin:/usr/lpp/db2c10/jdbc/bin:/bin:/usr/sbin:/usr/lpp/java/J8.0_64/bin:/usr/lpp/IBM/cobol/igyv6r3/bin:/usr/lpp/IBM/pli/v5r3/bin:/usr/lpp/IBM/zoautil/bin:/usr/lpp/IBM/cyp/v3r8/pyz/bin"
    PERL5LIB="/prj/git005/perl/lib/perl5/5.37.9:/prj/git005/perl/lib/perl5/5.37.9/os390"
    PERL5_HOME="/prj/git005/perl"
    TERM="xterm"
    _BPXK_AUTOCVT="ON"
    _CC_RUNOPTS=""
    _CEE_RUNOPTS="FILETAG(AUTOCVT,AUTOTAG) POSIX(ON)"
    _CXX_RUNOPTS=""
    _TAG_REDIR_ERR="txt"
    _TAG_REDIR_IN="txt"
    _TAG_REDIR_OUT="txt"
    export GIT_SSL_CAINFO=/prj/git005/cacert.pem
    export TERMINFO=/prj/git005/ncurses/share/terminfo


    That was easy! Source /prj/git005/envfile and try 'git' :)

After sourcing that file (you can append to your .profile) the products will be usable.

    >. /prj/git005/envfile
    >command -v git
    /prj/git005/git/bin/git

The terminal settings still don't work 100% (gotta see if that's something this installer messes up, or if ncurses itself does that...)

    >git diff README.md 
    WARNING: terminal is not fully functional
    Press RETURN to continue

Luckily after the WARNING, the diff shows properly (can't show colors here :( )

    diff --git a/README.md b/README.md
    index 9be1b18..95ba0c7 100644
    --- a/README.md
    +++ b/README.md
    @@ -25,6 +25,118 @@ This will generate a oneclick installer for git from ZOT. You need some space to

    *Make sure* to have enough space for running the resulting gitinstaller.sh

    +# Usage overview
    +
    +After downloading (or building) the gitinstaller.sh and uploading it to you Mainframe yo umust run gitinstaller.sh like so:
    +

## Versions

Currently embedded versions

* https://github.com/ZOSOpenTools/bashport/releases/download/bashport_605/bash-5.2.20230226_190557.zos.pax.Z 
* https://github.com/ZOSOpenTools/perlport/releases/download/perlport_531/perl5-blead.20230316_225400.zos.pax.Z 
* https://github.com/ZOSOpenTools/ncursesport/releases/download/ncursesport_618/ncurses-6.3.20230306_010811.zos.pax.Z
* https://github.com/ZOSOpenTools/lessport/releases/download/lessport_549/less-608.20230306_103304.zos.pax.Z
* https://github.com/ZOSOpenTools/gitport/releases/download/gitport_519/git-2.39.2.20230313_123033.zos.pax.Z 

