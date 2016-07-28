DB = ConnectionPool.new(capacity: ENV["DB_POOL_CAPACITY"].to_i, timeout: ENV["DB_POOL_TIMEOUT"].to_f) do
  PG.connect(ENV["PG_URL"])
end