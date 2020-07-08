##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : misc.sh                                                       ##
##  Project   : dots                                                          ##
##  Date      : Jan 06, 2019                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2019                                                ##
##                                                                            ##
##  Description :                                                             ##
##    Miscelaneous stuff that IDK where to place.                             ##
##---------------------------------------------------------------------------~##

##---------------------------------------------------------------------------~##
## Functions                                                                  ##
##---------------------------------------------------------------------------~##
##------------------------------------------------------------------------------
function weather()
{
    ## imrpove(stdmatt): Maybe cache the results???
    local ARGS="$@";
    ARGS=$(echo "$ARGS" | sed s/" "/"+"/g);

    curl -s wttr.in/"$ARGS" > /var/tmp/weather.txt;

    cat /var/tmp/weather.txt | head -1
    cat /var/tmp/weather.txt | head -37 | tail -30
}


##------------------------------------------------------------------------------
function check-my-repos()
{
    repochecker --remote --auto-pull --show-all
}
