##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : shell.sh                                                      ##
##  Project   : dots                                                          ##
##  Date      : Oct 12, 2018                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2018                                                ##
##                                                                            ##
##  Description :                                                             ##
##    Some aliases and functions to the life in shell easier.                 ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source "/usr/local/src/pixelwizards/shellscript_utils/main.sh"

##----------------------------------------------------------------------------##
## find-name                                                                  ##
##----------------------------------------------------------------------------##
find-name()
{
    test -z "$1" && \
        echo "Missing start path - Aborting..." && \
        return 1;

    test -z "$2" && \
        echo "Missing filename regex - Aborting..." && \
        return 1;

    find "$1" -iname "$2";
}

##----------------------------------------------------------------------------##
## ls                                                                         ##
##----------------------------------------------------------------------------##
alias ls="ls -F -G -h -p";
alias la="ls -A";
alias ll="ls -l"


##----------------------------------------------------------------------------##
## PATH                                                                       ##
##----------------------------------------------------------------------------##
PATH-add()
{
    if [ -z "$1" ]; then
        echo "[PATH-add] Empty path - Ignoring...";
        return 1;
    fi;

    PATH="$1:$PATH";
    echo "[PATH-add] Success...";
    echo "$PATH";
}


##----------------------------------------------------------------------------##
## Files                                                                      ##
##   Open the Filesystem Manager into a given path.                           ##
##   If no path was given open the current dir.                               ##
##----------------------------------------------------------------------------##
files()
{
    ## Initialize the destination path to the current dir.
    local path=".";

    ## Check if the input is comming from a pipe (stdin) or
    ## from the arguments...
    if [ -t 0 ]; then
        ## User (Myself actually :P) passed a custom path...
        if [ ! -z "$1" ]; then
            path=$1;
        fi;
    else
        read path;
    fi;

    local curr_os=$(pw_os_get_simple_name);
    local files_mgr="";
    if [ "$curr_os" == "$(PW_OS_OSX)" ]; then
        files_mgr="open";
    fi;


    ## Don't write the error messages into the terminal.
    $files_mgr 2> /dev/null $path;
}

##----------------------------------------------------------------------------##
## sudo                                                                       ##
##----------------------------------------------------------------------------##
please()
{
    sudo $@;
}
