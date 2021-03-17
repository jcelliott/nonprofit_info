# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nonprofit_info,
  ecto_repos: [NonprofitInfo.Repo]

config :nonprofit_info, NonprofitInfo.Repo,
  migration_primary_key: [type: :binary_id],
  migration_timestamps: [type: :utc_datetime]

# Configures the endpoint
config :nonprofit_info, NonprofitInfoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QkGGH3Tet4IYacSvmZfm/8QF7aS+PMUpMsA4DGksEKsb8rk4ESAwwvMWi+fJQHtf",
  render_errors: [view: NonprofitInfoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NonprofitInfo.PubSub,
  live_view: [signing_salt: "Ja5anKFU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kaffy,
  otp_app: :nonprofit_info,
  ecto_repo: NonprofitInfo.Repo,
  router: NonprofitInfoWeb.Router

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
