#!/usr/bin/env bash
##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : install.sh                                                    ##
##  Project   : dots                                                          ##
##  Date      : Oct 08, 2017                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2018                                                ##
##                                                                            ##
##  Description :                                                             ##
##    Super, super simple (and inclomple) install script for dots.            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source /usr/local/src/pixelwizards/shellscript_utils/main.sh


##----------------------------------------------------------------------------##
## Variables                                                                  ##
##----------------------------------------------------------------------------##
INSTALL_DIR="$HOME/.stdmatt/dots";


##----------------------------------------------------------------------------##
## Functions                                                                  ##
##----------------------------------------------------------------------------##
_install_source_on()
{
    local PATH_TO_INSTALL="$1";
    echo "Installing dots on ($PATH_TO_INSTALL)";

    if [ ! -e "$PATH_TO_INSTALL" ]; then
        pw_log_fatal "$PATH_TO_INSTALL does not exists - Aborting...";
    fi;

    local result=$(cat "$PATH_TO_INSTALL" | grep "source $INSTALL_DIR/main.sh");
    if [ -z "$result" ]; then
        echo "## stdmatt's dots ##"        >> "$PATH_TO_INSTALL";
        echo "source $INSTALL_DIR/main.sh" >> "$PATH_TO_INSTALL";
    fi;

    echo "Done...";
}


##----------------------------------------------------------------------------##
## Script                                                                     ##
##----------------------------------------------------------------------------##
##
## Install the script files.
##   Clear the installation directory.
rm -rf "$INSTALL_DIR";
mkdir "$INSTALL_DIR";

##
##   Copy all scripts to it.
cp -R ./src/* $INSTALL_DIR;

##
## Add a entry on the .bash_rc / .bash_profile so we can use the dots files.
DEFAULT_BASH_RC=$(pw_get_default_bashrc_or_profile);
USE_BASH_RC=$(pw_getopt_exists "$@" "--bashrc");
USE_BASH_PROFILE=$(pw_getopt_exists $@ "--bash-profile");

if [ -n "$USE_BASH_RC" ]; then
    _install_source_on "$HOME/.bashrc";
elif [ -n "$USE_BASH_PROFILE" ]; then
    _install_source_on "$HOME/.bash_profile";
else
    _install_source_on $DEFAULT_BASH_RC;
fi
