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
##  Copyright : stdmatt - 2018, 2019                                          ##
##                                                                            ##
##  Description :                                                             ##
##    Some aliases and functions to the life in shell easier.                 ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source "/usr/local/src/stdmatt/shellscript_utils/main.sh"


##----------------------------------------------------------------------------##
## ls                                                                         ##
##----------------------------------------------------------------------------##
alias ls="ls -F -G -h -p";
alias la="ls -A";
alias ll="ls -l"


##----------------------------------------------------------------------------##
## PATH                                                                       ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
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
##------------------------------------------------------------------------------
files()
{
    ## Initialize the destination path to the current dir.
    local TARGET_PATH=".";

    ## Check if the input is comming from a pipe (stdin) or
    ## from the arguments...
    if [ -t 0 ]; then
        ## User (Myself actually :P) passed a custom path...
        if [ ! -z "$1" ]; then
            TARGET_PATH=$1;
        fi;
    else
        read TARGET_PATH;
    fi;

    local CURR_OS=$(pw_os_get_simple_name);
    local FILE_MANAGER="";

    ## TODO(stdmatt): Make work on GNU.
    if [ "$CURR_OS" == "$(PW_OS_OSX)" ]; then
        FILE_MANAGER="open";
    elif [ "$CURR_OS" == "$(PW_OS_WINDOWS)" ]; then
        FILE_MANAGER="explorer.exe";
    fi;

    ## Don't write the error messages into the terminal.
    $FILE_MANAGER 2> /dev/null $TARGET_PATH;
}

##----------------------------------------------------------------------------##
## sudo                                                                       ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
please()
{
    sudo $@;
}


##----------------------------------------------------------------------------##
## Profile                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
edit-profile()
{
    local PROFILE_PATH=$(pw_get_default_bashrc_or_profile);
    ed "$PROFILE_PATH";
}

reload-profile()
{
    local PROFILE_PATH=$(pw_get_default_bashrc_or_profile);
    source "$PROFILE_PATH";

    echo "[reload-profile] Done...";
}

##----------------------------------------------------------------------------##
## Documentation                                                              ##
##----------------------------------------------------------------------------##
alias man="manpdf";
alias pydoc="pypdf";
