require "../config/environment"

Kemal.config.tap do |c|
  c.port = ENV["PORT"].to_i
  c.serve_static = false
end
Kemal.run unless ENV["ENV"] == "test"
