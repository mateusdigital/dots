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
    echo "..."
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
## VERSION                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
DOTS_VERSION="1.0.1";
##------------------------------------------------------------------------------
dots_version()
{
    echo "$DOTS_VERSION";
}


##----------------------------------------------------------------------------##
## Youtube-dl                                                                 ##
##----------------------------------------------------------------------------##
youtube-dl-mp3()
{
    local URL="$1";
    test -z "$URL"                                         \
        && echo "[youtube-dl-mp3] Empty url - Aborting..." \
        return 1;

    youtube-dl --no-playlist --extract-audio --audio-format mp3 "$URL";
}

##------------------------------------------------------------------------------
youtube-dl-playlist()
{
    local URL="$1";
    test -z "$URL"                                              \
        && echo "[youtube-dl-playlist] Empty url - Aborting..." \
        return 1;

    youtube-dl -o                                             \
        '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
        "$URL";
}

##------------------------------------------------------------------------------
youtube-dl-music-playlist()
{
    local URL="$1";
    test -z "$URL"                                              \
        && echo "[youtube-dl-playlist] Empty url - Aborting..." \
        return 1;

    youtube-dl                                                \
        --extract-audio --audio-format mp3                    \
        -o                                                    \
        '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
        "$URL";
}

##------------------------------------------------------------------------------
youtube-dl-channel()
{
    local URL="$1";
    test -z "$URL"                                             \
        && echo "[youtube-dl-channel] Empty url - Aborting..." \
        return 1;

    youtube-dl -o                                                          \
        '%(uploader)s/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' \
        "$URL"
}
