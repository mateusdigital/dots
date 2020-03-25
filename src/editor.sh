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
## Functions                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
charm()
{
    ## @todo(stdmatt): We try to find charm and not hardcode it...
    local CHARM_PATH="/usr/local/bin/charm";
    $CHARM_PATH $@ &
}

##------------------------------------------------------------------------------
edit-project-list()
{
    ## Rely on gosh to know where's the file to edit...
    local OWNCLOUD_PATH=$(gosh -p "owncloud");
    local PROJECT_LIST_FILENAME="$(find "$OWNCLOUD_PATH" -iname "projects_list.md")";

    if [ ! -f "${PROJECT_LIST_FILENAME}" ]; then
        pw_func_log \
           "Can't find the project list file at (${OWNCLOUD_PATH})";
        return 1;
    fi;

    $VISUAL_GUI "$PROJECT_LIST_FILENAME";
}

##------------------------------------------------------------------------------
edit-profile()
{
    local PROFILE_PATH=$(pw_get_default_bashrc_or_profile);
    $VISUAL_GUI "$PROFILE_PATH";
}
