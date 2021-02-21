require "uuid"

# A method to help generate group ids.
def generate_group_id(redis)
  loop do
    id = UUID.random.hexstring
    break id if !redis.exists(id) == 0
  end
end
