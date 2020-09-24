# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :encore,
  ecto_repos: [Encore.Repo]

# Configures the endpoint
config :encore, EncoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ioyTq9rYZyrS/K77QBlYKYfTr+wKJPwe2Rjckj14SoGjOju8SjBnyL2FjoMv12Gr",
  render_errors: [view: EncoreWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Encore.PubSub,
  live_view: [signing_salt: "y+P3JPmQ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
