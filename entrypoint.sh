# wait until Postgres is ready
while ! pg_isready -q -h db -p 5432 -U postgres
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

bin="/app/bin/hello_iot_cloud"
# start the elixir application
eval "$bin eval \"HelloIotCloud.Release.migrate\""
exec "$bin" "start"