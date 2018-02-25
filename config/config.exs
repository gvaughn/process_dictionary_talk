# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lonestar_pd,
  ecto_repos: [LonestarPd.Repo]

# Configures the endpoint
config :lonestar_pd, LonestarPdWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nK7A3Y8YJ1BioS7uzMHJDV5jFZWaQqbmbj3SLrpR+8tephqw7BE98WZLZIyuHoW4",
  render_errors: [view: LonestarPdWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LonestarPd.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
