connect-clickhouse-client()
{
    docker run -it --rm --link clickhouse_storage_service:clickhouse_storage_service yandex/clickhouse-client --host clickhouse_storage_service
}