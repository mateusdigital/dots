##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : dosbox.sh                                                     ##
##  Project   : dots                                                          ##
##  Date      : Oct 16, 2018                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2018                                                ##
##                                                                            ##
##  Description :                                                             ##
##    Functions and aliases to make the dosbox usage nicer.                   ##
##---------------------------------------------------------------------------~##

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
