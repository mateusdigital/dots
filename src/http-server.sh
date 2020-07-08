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
HTTP_SERVER_CMD="python3 -m http.server 8000 --bind localhost";
TEMP_DIRECTORY="/var/tmp";
TEMP_FILENAME="http-server.temp";
TEMP_FULLPATH="${TEMP_DIRECTORY}/${TEMP_FILENAME}"


##----------------------------------------------------------------------------##
## Private Functions                                                          ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
_http_ensure_directories()
{
    ## notice(stdmatt): On Windows MINGW64_NT-10.0-18362 bash shell
    ## we don't have the /var/tmp directory. So we need to create it.
    if [ ! -d "$TEMP_DIRECTORY" ]; then
        pw_log_warning                                             \
            "Temporary directory ($TEMP_DIRECTORY) doesn't exists" \
            "Creating it now...";

        pw_as_super_user \
            mkdir -pv "$TEMP_DIRECTORY";
    fi;
}

##----------------------------------------------------------------------------##
## Functions                                                                  ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
http-kill()
{
    _http_ensure_directories;

    local HTTP_SERVER_PID=$(cat "$TEMP_FULLPATH");
    if [ -n "$HTTP_SERVER_PID" ]; then
        echo "[http-kill] (PID: $HTTP_SERVER_PID) - Killing it...";
        kill -9 "$HTTP_SERVER_PID";
    else
        echo "[http-kill] No running server...";
    fi;

    echo "" > "$TEMP_FULLPATH";
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
    local FULL_CMD="$HTTP_SERVER_CMD";
    ($FULL_CMD  >/dev/null 2>&1 & echo "$!" > $TEMP_FULLPATH ) &
    echo "[http-sever] PID for http-serve is: $(cat $TEMP_FULLPATH)"
}
