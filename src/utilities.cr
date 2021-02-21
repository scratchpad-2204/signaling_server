# A macro to simplify handling HTTPExceptions in code.
macro handle_http_exception(env, exception)
  log("[#{{{exception}}.code}] #{{{exception}}.class.name}: #{{{exception}}.message}")
  log("Stack Trace:\n#{{{exception}}.backtrace.join("\n")}")
  if {{exception}}.data.nil?
    halt {{env}}, status_code: {{exception}}.code, response: {{exception}}.data.to_json
  else
    halt {{env}}, status_code: {{exception}}.code, response: {{exception}}.data.to_json
  end
end

# A macro that provides the exception handling for processing a standard
# web request.
macro for_request(&block)
{% if block %}
  begin
    {{block.body}}
  rescue error : HTTPException
    # puts "#{error.class.name} Exception: #{error}\n#{error.backtrace.join("\n")}"
    handle_http_exception(env, error)
  rescue error
    # puts "#{error.class.name} Exception: #{error}\n#{error.backtrace.join("\n")}"
    handle_exception(env, error)
  end
{% else %}
  internal_server_error("The for_request macro was invoked but no block provided.")
{% end %}
end

# A macro to handle catching non-HTTP exceptions.
macro handle_exception(env, exception)
  log("[500] #{{{exception}}.class.name}: #{{{exception}}.message}")
  log("Stack Trace:\n#{{{exception}}.backtrace.join("\n")}")
  content = {message: "Internal server error."}.to_json
  halt {{env}}, status_code: 500, response: content
end

# A macro to raise an bad request HTTP exception.
macro bad_request(cause, response="Bad Request")
  raise BadRequestException.new({{cause}}, {"message" => {{response}}})
end

# A macro to raise an forbidden HTTP exception.
macro forbidden(cause, response="Forbidden")
  raise ForbiddenException.new({{cause}}, {"message" => {{response}}})
end

# A macro to raise an internal server error HTTP exception.
macro internal_server_error(cause, response="Internal Server Error")
  raise InternalServerErrorException.new({{cause}}, {"message" => {{response}}})
end

# A macro to raise an not found HTTP exception.
macro not_found(cause, response="Not Found")
  raise NotFoundException.new({{cause}}, {"message" => {{response}}})
end

# A macro to raise an unauthorized HTTP exception.
macro unauthorized(cause, response="Unauthorized")
  raise UnauthorizedException.new({{cause}}, {"message" => {{response}}})
end

# A macro that encapsulates standard functionality for calling a halt to request
# processing on a request that has hit a problem.
macro fail_request(env, code, error, message)
  log("[{{code}}] #{{{error}}}")
  content = {message: {{message}}}.to_json
  halt {{env}}, status_code: {{code}}, response: content
end

# A macro to wrap the extraction of request configuration.
macro get_configuration(env)
  {{env}}.get("configuration").as(Totem::Config)
end

# A macro to wrap the extraction of request configuration.
macro get_redis(env)
  {{env}}.get("redis").as(Redis::PooledClient)
end
