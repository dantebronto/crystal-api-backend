require "../config/environment"

Kemal.config.port = ENV["PORT"].to_i
Kemal.run
