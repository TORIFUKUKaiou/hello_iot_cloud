defmodule HelloIotCloud.Repo do
  use Ecto.Repo,
    otp_app: :hello_iot_cloud,
    adapter: Ecto.Adapters.Postgres
end
