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
##  Date      : Oct 02, 2018                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt 2018 - 2021                                           ##
##                                                                            ##
##  Description :                                                             ##
##    Super, super simple (and incomplete) install script for dots.           ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
test ! -f "$HOME/.ark/ark_shlib/main.sh" && echo "Please install ark_shlib (https://gitlab.com/arkadia_games/libs/ark_shlib)" && exit 1;
source "$HOME/.ark/ark_shlib/main.sh"

##----------------------------------------------------------------------------##
## Variables                                                                  ##
##----------------------------------------------------------------------------##
INSTALL_DIR="$HOME/.stdmatt/dots";
SCRIPT_DIR="$(ark_get_script_dir)";


##----------------------------------------------------------------------------##
## Functions                                                                  ##
##----------------------------------------------------------------------------##
_install_source_on()
{
    local PATH_TO_INSTALL="$1";
    echo "Installing dots on ($PATH_TO_INSTALL)";

    if [ ! -e "$PATH_TO_INSTALL" ]; then
        ark_log_fatal "$PATH_TO_INSTALL does not exists - Aborting...";
    fi;

    local result=$(cat "$PATH_TO_INSTALL" | grep "source $INSTALL_DIR/main.sh");
    if [ -z "$result" ]; then
        echo "## stdmatt's dots ##"        >> "$PATH_TO_INSTALL";
        echo "source $INSTALL_DIR/main.sh" >> "$PATH_TO_INSTALL";

        ## macOS has the zsh as default now, but I want to continue to use bash ;D
        if [ -n "$(ARK_OS_IS_MACOS)" ]; then
            echo "export BASH_SILENCE_DEPRECATION_WARNING=1" >> "$PATH_TO_INSTALL";
        fi;
    fi;

    echo "Done...";
}


##----------------------------------------------------------------------------##
## Script                                                                     ##
##----------------------------------------------------------------------------##
echo "[Installing dots]";

##
## Install the script files.
##   Clear the installation directory.
rm    -rf  "$INSTALL_DIR";
mkdir -pv  "$INSTALL_DIR";
cp    -fv  "$SCRIPT_DIR/src/main.sh"       "$INSTALL_DIR";
cp    -fv  "$SCRIPT_DIR/extras/.vimrc"     "$HOME";
cp    -fv  "$SCRIPT_DIR/extras/.gitignore" "$HOME";

echo "Installing profile...";
_install_source_on "$HOME/.bashrc";

echo "Configuring git...";
git config --global user.name         "stdmatt";
git config --global user.email        "stdmatt@pixelwizards.io";
git config --global core.excludesfile "$HOME/.gitignore";

echo "Done... ;D";
echo "";
##
## @todo(stdmatt): Install the gitignore
## git config --global core.excludesfile ~/.gitignore_global
