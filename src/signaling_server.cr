require "json"
require "kemal"
require "redis"
require "totem"
require "yaml"
require "./configuration"
require "./exceptions"
require "./parameter_helpers"
require "./utilities"
require "./member"
require "./group"
require "./routes"

begin
  configuration = load_configuration
  redis         = create_redis_pool(configuration)
  sockets       = Array(HTTP::WebSocket).new

  add_context_storage_type(Array(HTTP::WebSocket))
  add_context_storage_type(Totem::Config)
  add_context_storage_type(Redis::PooledClient)
  before_all do |env|
    env.set "configuration", configuration
    env.set "redis", redis
    env.set "sockets", sockets
  end

  Kemal.run
rescue error
  STDERR.puts "ERROR: #{error}\n#{error.backtrace.join("\n")}"
end