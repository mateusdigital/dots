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
##  Copyright : stdmatt 2018 - 2020                                           ##
##                                                                            ##
##  Description :                                                             ##
##    This is the only file that will be sourced in .bashrc (.bash_profile)   ##
##    so everything that dots needs to source must be sourced from this file  ##
##    This will make all the stuff avaiable but without the hassle of         ##
##    need to include everything by hand.                                     ##
##    Thanks me later....                                                     ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Variables                                                                  ##
##----------------------------------------------------------------------------##
PROJECT_ROOT_DIR="$HOME/.stdmatt/dots";


##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source "$PROJECT_ROOT_DIR/datetime.sh"
source "$PROJECT_ROOT_DIR/dosbox.sh"
source "$PROJECT_ROOT_DIR/editor.sh"
source "$PROJECT_ROOT_DIR/emscripten.sh"
source "$PROJECT_ROOT_DIR/http-server.sh"
source "$PROJECT_ROOT_DIR/keyboard.sh"
source "$PROJECT_ROOT_DIR/misc.sh"
source "$PROJECT_ROOT_DIR/network.sh"
source "$PROJECT_ROOT_DIR/playground.sh"
source "$PROJECT_ROOT_DIR/PS1.sh"
source "$PROJECT_ROOT_DIR/shell.sh"
source "$PROJECT_ROOT_DIR/youtube-dl.sh"
source "$PROJECT_ROOT_DIR/version.sh"

## Hacks for each platform...
source "$PROJECT_ROOT_DIR/osx_hacks.sh"
source "$PROJECT_ROOT_DIR/windows_hacks.sh"
