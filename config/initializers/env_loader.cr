ENV["ENV"] ||= "development"

config = YAML.parse(File.read(File.expand_path("#{__DIR__}/../env.yml")))
config[ENV["ENV"]].each do |key, value|
  ENV[key.to_s] = value.to_s unless ENV.has_key?(key.to_s)
end
