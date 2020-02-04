connect-clickhouse-client()
{
    docker run -it --rm --link clickhouse_storage_database:clickhouse_storage_database yandex/clickhouse-client --host clickhouse_storage_database
}
