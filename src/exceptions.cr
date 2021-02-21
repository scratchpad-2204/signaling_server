# This file contains declarations for the various exception types used throughout
# the application.

# This is the base exception class used for errors within the application.
class ServerException < ::Exception
end


# An exception type used to generate exceptions that result in specific
# types of HTTP responses.
class HTTPException < ServerException
  # Instance data.
  @code : Int32
  @data : Hash(String, String)?

  getter :code, :data

  def initialize(message, @code=400, @data : Hash(String, String)?=nil)
      super(message)
  end
end

# An exception type for the Bad Request HTTP status.
class BadRequestException < HTTPException
  def initialize(message, @data : Hash(String, String)?=nil)
    super(message, 400, data)
  end
end

# An exception type for the Unauthorized HTTP status.
class UnauthorizedException < HTTPException
  def initialize(message, @data : Hash(String, String)?=nil)
    super(message, 401, data)
  end
end

# An exception type for the Unauthorized HTTP status.
class ForbiddenException < HTTPException
  def initialize(message, @data : Hash(String, String)?=nil)
    super(message, 403, data)
  end
end

# An exception type for the Not Found HTTP status.
class NotFoundException < HTTPException
  def initialize(message, @data : Hash(String, String)?=nil)
    super(message, 404, data)
  end
end
