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
PYTHON_EXTENSIONS="pdfkit";
BREW_EXTENSIONS="Caskroom/cask/wkhtmltopdf";


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
mkdir -p "$INSTALL_DIR";
##   Copy all scripts to it.
cp -R ./src/* $INSTALL_DIR;

##
## Add a entry on the .bash_rc / .bash_profile so we can use the dots files.
default_bash_rc=$(pw_get_default_bashrc_or_profile);
use_bash_rc=$(pw_getopt_exists "$@" "--bashrc");
use_bash_profile=$(pw_getopt_exists $@ "--bash-profile");
install_everything=$(pw_getopt_exists $@ "--everything");

if [ -n "$use_bash_rc" ]; then
    _install_source_on "$HOME/.bashrc";
elif [ -n "$use_bash_profile" ]; then
    _install_source_on "$HOME/.bash_profile";
else
    _install_source_on $default_bash_rc;
fi

if [ -n "$install_everything" ]; then
    ##
    ## Install python extensions.
    for item in $PYTHON_EXTENSIONS; do
        sudo pip install "$item";
    done;

    ##
    ## Install brew extensions.
    for item in $BREW_EXTENSIONS; do
        brew install "$item";
    done;
fi;
