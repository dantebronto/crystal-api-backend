require "../config/environment"

Kemal.run unless ENV["ENVIRONMENT"] == "test"
