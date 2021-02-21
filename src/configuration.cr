# Constant for the default configuration path.
DEFAULT_CONFIGURATION_PATH = File.join(Dir.current, "configuration.yml")

# The default Redis host name.
DEFAULT_REDIS_HOST = "localhost"

# The default Redis pool size.
DEFAULT_REDIS_POOL_SIZE = 5

# The default Redis port number.
DEFAULT_REDIS_PORT = 6379

# Create a new Redis connection pool.
def create_redis_pool(configuration) : Redis::PooledClient
  host     = DEFAULT_REDIS_HOST
  port     = DEFAULT_REDIS_PORT
  size     = DEFAULT_REDIS_POOL_SIZE
  settings = configuration.get("redis").as_h?
  if settings
    host = settings["host"]? ? settings["host"].as_s : DEFAULT_REDIS_HOST
    port = settings["port"]? ? settings["port"].as_i : DEFAULT_REDIS_PORT
    size = settings["max_size"]? ? settings["max_size"].as_i : DEFAULT_REDIS_POOL_SIZE
  end
  Redis::PooledClient.new(host: host, port: port, pool_size: size)
end

# Loads the application configuration file.
def load_configuration(path : String = DEFAULT_CONFIGURATION_PATH)
  raise ServerException.new("The '#{path}' configuration file does not exist.") if !File.exists?(path)
  Totem.from_file path
end