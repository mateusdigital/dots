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
##     Makes the python's simple http server can be started in a              ##
##     deamon-ish way.                                                        ##
##                                                                            ##
##     So we can just call the function in the directory that we want         ##
##     to serve and the script will take care of make the old server goes     ##
##     away!                                                                  ##
##                                                                            ##
##     Today I got married <3 Hope that I can live a very beautiful life      ##
##     with Sasha - like we're already doing!                                 ##
##                                                                            ##
##     Quite happy!!!                                                         ##
##----------------------------------------------------------------------------##


##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source "/usr/local/src/stdmatt/shellscript_utils/main.sh"


##----------------------------------------------------------------------------##
## Constants                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
HTTP_SERVER_CMD="python -m SimpleHTTPServer";
HTTP_SERVER_PORT="8000";


##----------------------------------------------------------------------------##
## Functions                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
http-kill()
{
    local TEMP_FILENAME="/var/tmp/http-server.temp"

    ## notice(stdmatt): need to use "aex" flags, cause since were are forking
    ## the process it will not show up so nicely in just plain ps(1).
    ps aex > "$TEMP_FILENAME";
    local PS_RESULT=$(pw_trim $(cat "$TEMP_FILENAME" | grep "$HTTP_SERVER_CMD"));
    if [ -n "$PS_RESULT" ]; then
        local HTTP_SERVER_PID=$(echo "$PS_RESULT" | cut -d " " -f1);
        echo "[http-kill] (PID: $HTTP_SERVER_PID) - Killing it...";
        kill -9 "$HTTP_SERVER_PID";
    else
        echo "[http-kill] No running server...";
    fi;
}


##------------------------------------------------------------------------------
http-server()
{
    ## Let's user specify the port.
    if [ -n "$1" ]; then
        HTTP_SERVER_PORT="$1";
    fi;

    http-kill;

    echo "[http-server] Start to serve at ($PWD)...";
    ## Double fork trick:
    ##    https://stackoverflow.com/a/3430969
    ##    https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap11.html#tag_11_01_03
    local FULL_CMD="$HTTP_SERVER_CMD $HTTP_SERVER_PORT";
    ($FULL_CMD  >/dev/null 2>&1 &) &
}
