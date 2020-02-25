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
    local OLD_CWD="$PWD";

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
    TARGET_PATH="$(pw_realpath $TARGET_PATH)";

    local CURR_OS=$(pw_os_get_simple_name);
    local FILE_MANAGER="";

    if [ "$CURR_OS" == "$(PW_OS_GNU_LINUX)" ]; then
        FILE_MANAGER="xdg-open";
    elif [ "$CURR_OS" == "$(PW_OS_OSX)" ]; then
        FILE_MANAGER="open";
    elif [ "$CURR_OS" == "$(PW_OS_WINDOWS)" ]; then
        FILE_MANAGER="explorer.exe";
    elif [ "$CURR_OS" == "$(PW_OS_WSL)" ]; then
        FILE_MANAGER="explorer.exe";
    fi;

    cd "$TARGET_PATH";
        $FILE_MANAGER 2> /dev/null .
    cd "$OLD_CWD";
}

##------------------------------------------------------------------------------
count-files()
{
    ls -1 $1 | wc -l;
}

##------------------------------------------------------------------------------
count-file-lines()
{
    local ARGS_COUNT=${#@};
    if [ $ARGS_COUNT == 0 ]; then
        echo "[count-files] Missing filename.";
        return 1;
    fi;

    for FILENAME in $@; do
        local LINES_COUNT=$(cat "$FILENAME" | wc -l);
        if [ $ARGS_COUNT == 1 ]; then
            echo $LINES_COUNT;
        else
            echo "$FILENAME: $LINES_COUNT";
        fi;
    done;
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

##------------------------------------------------------------------------------
reload-profile()
{
    local PROFILE_PATH=$(pw_get_default_bashrc_or_profile);
    source "$PROFILE_PATH";

    echo "[reload-profile] Done...";
}
