# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gallery,
  ecto_repos: [Gallery.Repo]

# Configures the endpoint
config :gallery, GalleryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/DnRn5TteHYy7w669SjVYzSQRm4deDCle55B4M70no6GX4DzcQim2+H905iwEcAW",
  render_errors: [view: GalleryWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Gallery.PubSub,
  live_view: [signing_salt: "2o5gWF2L"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
