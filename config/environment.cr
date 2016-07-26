require "kemal"
require "yaml"
require "jwt"
require "pg"
require "pool/connection"
require "./routing_engine"

ENV["ENV"] ||= "development"

config = YAML.parse(File.read(File.expand_path("#{__DIR__}/env.yml")))
config[ENV["ENV"]].each do |key, value|
  ENV[key.to_s] = value.to_s unless ENV.has_key?(key.to_s)
end

DB = ConnectionPool.new(capacity: ENV["DB_POOL_CAPACITY"].to_i, timeout: ENV["DB_POOL_TIMEOUT"].to_f) do
  PG.connect(ENV["PG_URL"])
end

require "../src/lib/**"
require "../src/concepts/**"
require "./routes"