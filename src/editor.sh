##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : editor.sh                                                     ##
##  Project   : dots                                                          ##
##  Date      : Dec 01, 2019                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt 2019, 2020                                            ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Exports                                                                    ##
##----------------------------------------------------------------------------##
export EDITOR=vim;
export VISUAL=vim;
export VISUAL_GUI="code";


##----------------------------------------------------------------------------##
## Editors                                                                    ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
wcode()
{
    if [ -n "$(PW_OS_IS_WSL)" ]; then
        powershell -Command "code .";
    else
        code .
    fi;
}


##----------------------------------------------------------------------------##
## Edit Functions                                                             ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
_edit_file_in_owncloud()
{
    ## Rely on gosh to know where's the file to edit...
    local FILENAME="$1";
    local OWNCLOUD_PATH=$(gosh -p "owncloud");
    local EDIT_FILENAME="$(find "$OWNCLOUD_PATH" -iname "$FILENAME")";

    if [ ! -f "${EDIT_FILENAME}" ]; then
        pw_func_log \
           "Can't find ${FILENAME} list file at (${OWNCLOUD_PATH})";
        return 1;
    fi;

    $VISUAL_GUI "$EDIT_FILENAME";
}

##------------------------------------------------------------------------------
edit-profile()
{
    local PROFILE_PATH=$(pw_get_default_bashrc_or_profile);
    $VISUAL_GUI "$PROFILE_PATH";
}

##------------------------------------------------------------------------------
edit-project-list()
{
    _edit_file_in_owncloud "projects_list.md";
}
