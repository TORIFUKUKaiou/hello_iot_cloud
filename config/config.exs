# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hello_iot_cloud,
  ecto_repos: [HelloIotCloud.Repo]

# Configures the endpoint
config :hello_iot_cloud, HelloIotCloudWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "khWujTyzZITRk/UJ1xtzaClEv7sHWhKBF2QUcmq+vNI7e4FxGomPB2h5C953Qh0J",
  render_errors: [view: HelloIotCloudWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HelloIotCloud.PubSub,
  live_view: [signing_salt: "H9pz1CQa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
