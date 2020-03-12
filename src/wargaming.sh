##~---------------------------------------------------------------------------##
##                        _      _                 _   _                      ##
##                    ___| |_ __| |_ __ ___   __ _| |_| |_                    ##
##                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   ##
##                   \__ \ || (_| | | | | | | (_| | |_| |_                    ##
##                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   ##
##                                                                            ##
##  File      : wargaming.sh                                                  ##
##  Project   : dots                                                          ##
##  Date      : Feb 03, 2020                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : stdmatt <stdmatt@pixelwizards.io>                             ##
##  Copyright : stdmatt 2020                                                  ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##------------------------------------------------------------------------------
connect-clickhouse-client()
{
    docker run -it --rm --link                                   \
        clickhouse_storage_database:clickhouse_storage_database  \
        yandex/clickhouse-client                                 \
        --host clickhouse_storage_database
}

##------------------------------------------------------------------------------
connect-postgres()
{
    local NAME="pg-docker";
    local PASSWD="docker";

    docker kill "$NAME";
    docker purge -f;

    docker run -it --rm                                             \
        --name "$NAME"                                              \
        -e POSTGRES_PASSWORD="$PASSWD"                              \
        -p 5432:5432                                                \
        -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data   \
        postgres
}
