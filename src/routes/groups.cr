require "../group_helpers"

post "/groups" do |env|
  for_request do
    api_key        = required_parameter("api_key", env.params.json)
    configuration  = get_configuration(env)
    valid_api_keys = configuration.get("api_keys").as_a?
    if valid_api_keys && !valid_api_keys.includes?(api_key)
      forbidden("Invalid API key '#{api_key}' specified in request.")
    end

    redis    = get_redis(env)
    group_id = generate_group_id(redis)
    group    = {id:      group_id,
                members: Array(String).new}
    redis.set(group_id, group.to_yaml)
    halt env, response: ({group_id: group_id, success: true}.to_json)
  end
end
