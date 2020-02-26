##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : bench.sh                                                      ##
##  Project   : dots                                                          ##
##  Date      : Feb 19, 2020                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt 2020                                                  ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source /usr/local/src/stdmatt/shellscript_utils/main.sh


##----------------------------------------------------------------------------##
## Functions                                                                  ##
##----------------------------------------------------------------------------##
_dots_bench()
{
    local ITERATIONS="$1";
    local PROG="$2";
    local SIZE=$(pw_strlen "$ITERATIONS");
    local CMD="$@";
    local ARGS=$(pw_substr "$CMD" $SIZE)

    ## echo "ITERATIONS $ITERATIONS";
    ## echo "SIZE       $SIZE";
    ## echo "CMD        $CMD";
    ## echo "ARGS       $ARGS";
    for i in $(seq 1 $ITERATIONS); do
        $ARGS;
    done;
}

bench()
{
    time _dots_bench $@
}
