Kemal.config.tap do |c|
  c.port = ENV["PORT"].to_i
  c.serve_static = false
end
