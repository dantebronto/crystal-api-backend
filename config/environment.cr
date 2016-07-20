require "kemal"
require "yaml"
require "pg"

ENV["ENVIRONMENT"] ||= "development"

config = YAML.parse(File.read(File.expand_path("#{__DIR__}/env.yml")))
config[ENV["ENVIRONMENT"]].each do |key, value|
  ENV[key.to_s] = value.to_s unless ENV.has_key?(key.to_s)
end

require "./routes"