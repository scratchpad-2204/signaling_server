require "../parameter_helpers"
require "./groups"

# Middleware to set the content type for all responses.
class SetOutputContentType < Kemal::Handler
  def call(context)
    # puts "PATH: #{context.request.path}"
    context.response.content_type = "application/json"
    call_next context
  end
end

add_handler SetOutputContentType.new
