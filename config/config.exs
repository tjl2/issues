# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :issues, github_url: "https://api.github.com"

config :logger,
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]
