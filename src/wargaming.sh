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

_WG_POSTGRES_IMG_NAME="pg-docker";

_WG_POSTGRES_USERNAME="postgres";
_WG_POSTGRES_PASSWORD="docker";
_WG_POSTGRES_HOST="localhost";

##------------------------------------------------------------------------------
wg-run-clickhouse-db()
{
    docker container kill clickhouse_storage_database
    docker container kill clickhouse_storage_service
    docker container prune --force

    docker run --rm -d                      \
        --publish 9000:9000                 \
        --ulimit nofile=262144:262144       \
        --name clickhouse_storage_database  \
        yandex/clickhouse-server
}

##------------------------------------------------------------------------------
wg-connect-clickhouse-client()
{
    docker run -it --rm --link                                   \
        clickhouse_storage_database:clickhouse_storage_database  \
        yandex/clickhouse-client                                 \
        --host clickhouse_storage_database
}

##------------------------------------------------------------------------------
wg-connect-postgres()
{
    psql -U $_WG_POSTGRES_USERNAME -h $_WG_POSTGRES_HOST;
}

##------------------------------------------------------------------------------
wg-run-postgres()
{
    docker kill "$_WG_POSTGRES_IMG_NAME";
    docker purge -f;

    docker run -it --rm                               \
        --name "$_WG_POSTGRES_IMG_NAME"               \
        -e POSTGRES_PASSWORD="$_WG_POSTGRES_PASSWORD" \
        -p 5432:5432                                  \
        postgres
}
