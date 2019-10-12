##----------------------------------------------------------------------------##
##                       __      __                  __   __                  ##
##               .-----.|  |_.--|  |.--------.---.-.|  |_|  |_                ##
##               |__ --||   _|  _  ||        |  _  ||   _|   _|               ##
##               |_____||____|_____||__|__|__|___._||____|____|               ##
##                                                                            ##
##  File      : http-server.sh                                                ##
##  Project   : dots                                                          ##
##  Date      : Oct 12, 2019                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt - 2019                                                ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##----------------------------------------------------------------------------##

##------------------------------------------------------------------------------
http-server()
{
    local TEMP_FILENAME="/var/tmp/http-server.temp"
    local HTTP_SERVER_CMD="python -m SimpleHTTPServer";
    local PORT="8000";

    ## Let's user specify the port.
    if [ -n "$1" ]; then
        PORT="$1";
    fi;

    ## notice(stdmatt): need to use "aex" flags, cause since were are forking
    ## the process it will not show up so nicely in just plain ps(1).
    ps aex > "$TEMP_FILENAME";
    local PS_RESULT=$(cat "$TEMP_FILENAME" | grep "$HTTP_SERVER_CMD");
    if [ -n "$PS_RESULT" ]; then
        echo "[http-server] Is already running - Killing it...";
        local HTTP_SERVER_PID=$(echo "$PS_RESULT" | cut -d " " -f1);
        kill -9 "$HTTP_SERVER_PID";
    fi;

    echo "[http-server] Start to serve at ($PWD)...";
    ## Double fork trick:
    ##    https://stackoverflow.com/a/3430969
    ##    https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap11.html#tag_11_01_03
    ($HTTP_SERVER_CMD >/dev/null 2>&1 &) &
}
