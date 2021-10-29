##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : main.sh                                                       ##
##  Project   : dots                                                          ##
##  Date      : Oct 02, 2018                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt 2018 - 2021                                           ##
##                                                                            ##
##----------------------------------------------------------------------------##

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source "$HOME/.ark/ark_shlib/main.sh"


##----------------------------------------------------------------------------##
## DOSBox                                                                     ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
dosbox()
{
    local EXE_PATH=$"$1";
    local DOSBOX_PATH=$(which dosbox);

    ## We have an exe to run?
    test -z "$EXE_PATH"                \
        && echo "Missing .exe path..." \
        && return 1;

    ## We have dosbox installed?
    test -z "$DOSBOX_PATH"                   \
        && echo "dosbox isn't installed..."  \
        && return 1;

    ## -exit means that we gonna exit dosbox when the .exe exits itself.
    "$DOSBOX_PATH" -exit "$EXE_PATH";
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

    TARGET_PATH="$(ark_realpath $TARGET_PATH)";

    local CURR_OS=$(ark_get_os_simple_name);
    local FILE_MANAGER="";

    if [ "$CURR_OS" == "$(ARK_OS_NAME_GNU_LINUX)" ]; then
        FILE_MANAGER="xdg-open";
    elif [ "$CURR_OS" == "$(ARK_OS_NAME_MACOS)" ]; then
        FILE_MANAGER="open";
    elif [ "$CURR_OS" == "$(ARK_OS_NAME_WSL)" ]; then
        FILE_MANAGER="explorer.exe";
    fi;

    cd "$TARGET_PATH";
        $FILE_MANAGER 2> /dev/null .
    cd "$OLD_CWD";
}


##----------------------------------------------------------------------------##
## ls                                                                         ##
##----------------------------------------------------------------------------##
alias ls="ls -F -G -h -p";
alias la="ls -A";
alias ll="ls -l"
alias py="python3";


##----------------------------------------------------------------------------##
## PATH                                                                       ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
add-to-path()
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
## PS1                                                                        ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
_PS1_COLOR_PWD=64
_PS1_COLOR_GIT=241
_PS1_COLOR_PROMPT=247
_PS1_PROMPT_STR=":)"

##------------------------------------------------------------------------------
_ps1_parse_git_branch()
{
       BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
       if [ ! "${BRANCH}" == "" ]; then
          local USER_NAME="$(git config user.name)";
          local USER_EMAIL=$(git config user.email);

          local TAG=$(git describe --tags $(git rev-list --tags --max-count=1) 2> /dev/null);
          if [ -n "$TAG" ]; then
               STR="(${BRANCH}:${TAG})";
          else
               STR="(${BRANCH})";
          fi;
          echo "(${STR}) - $USER_NAME <$USER_EMAIL>";
       else
            echo ""
       fi
}

##------------------------------------------------------------------------------
export PS1="\n\[\033[38;5;${_PS1_COLOR_PWD}m\]\W\[$(tput sgr0)\]:\[\033[38;5;${_PS1_COLOR_GIT}m\]\`_ps1_parse_git_branch\`\[$(tput sgr0)\]\n\[$(tput bold)\033[38;5;${_PS1_COLOR_PROMPT}m\]${_PS1_PROMPT_STR}\[$(tput sgr0)\] "


##----------------------------------------------------------------------------##
## Profile                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
reload-profile()
{
    local PROFILE_PATH="$HOME/.bashrc";
    source "$PROFILE_PATH";

    echo "[reload-profile] Done...";
}

##------------------------------------------------------------------------------
edit-profile()
{
    local PROFILE_PATH="$HOME/.bashrc";
    code "$PROFILE_PATH";
}

##------------------------------------------------------------------------------
sync-profile()
{
    echo "... Need to implement it ...";
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
## Server                                                                     ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
_HTTP_SERVER_CMD="python3 -m http.server 8000 --bind localhost";
_HTTP_TEMP_DIR="/var/tmp";
_HTTP_TEMP_FILENAME="http-server.temp";
_HTTP_TEMP_FULLPATH="${_HTTP_TEMP_DIR}/${_HTTP_TEMP_FILENAME}";


##----------------------------------------------------------------------------##
## Private Functions                                                          ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
_http_ensure_directories()
{
    ## notice(stdmatt): On Windows MINGW64_NT-10.0-18362 bash shell
    ## we don't have the /var/tmp directory. So we need to create it.
    if [ ! -d "$_HTTP_TEMP_DIR" ]; then
        pw_log_warning                                             \
            "Temporary directory ($_HTTP_TEMP_DIR) doesn't exists" \
            "Creating it now...";

        pw_as_super_user \
            mkdir -pv "$_HTTP_TEMP_DIR";
    fi;
}

##----------------------------------------------------------------------------##
## Functions                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
http-kill()
{
    _http_ensure_directories;

    local HTTP_SERVER_PID=$(cat "$_HTTP_TEMP_FULLPATH");
    if [ -n "$HTTP_SERVER_PID" ]; then
        echo "[http-kill] (PID: $HTTP_SERVER_PID) - Killing it...";
        kill -9 "$HTTP_SERVER_PID";
    else
        echo "[http-kill] No running server...";
    fi;

    echo "" > "$_HTTP_TEMP_FULLPATH";
}

##------------------------------------------------------------------------------
http-server()
{
    ## Let's user specify the port.
    if [ -n "$1" ]; then
        HTTP_SERVER_PORT="$1";
    fi;

    http-kill;
    echo "[http-server] Start to serve at ($PWD)...";

    ## Double fork trick:
    ##    https://stackoverflow.com/a/3430969
    ##    https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap11.html#tag_11_01_03
    local FULL_CMD="$_HTTP_SERVER_CMD";
    ($FULL_CMD  >/dev/null 2>&1 & echo "$!" > $_HTTP_TEMP_FULLPATH ) &
    echo "[http-sever] PID for http-serve is: $(cat $_HTTP_TEMP_FULLPATH)"
}



##----------------------------------------------------------------------------##
## System                                                                     ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
system-update()
{
    sudo apt-get update && sudo apt-get upgrade;
}


##----------------------------------------------------------------------------##
## VERSION                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
DOTS_VERSION="1.0.1";
##------------------------------------------------------------------------------
dots-version()
{
    echo "$DOTS_VERSION";
}
