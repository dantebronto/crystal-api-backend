class MockRequest
  getter :io, :request, :env

  def initialize(verb : String, path : String, body : String?)
    @headers = {} of String => String
    @request = HTTP::Request.new(verb, path, nil, body)
    @io = MemoryIO.new
    @response = HTTP::Server::Response.new(@io)
    @env = HTTP::Server::Context.new(@request, @response)
  end

  def initialize(verb : String, path : String)
    initialize(verb, path, nil)
  end

  def header(key : String, value : String)
    @request.headers[key] = value
    self
  end

  def as_user(user : Users::Model)
    @env.set("uid", user.id.to_s)
    self
  end

  def json
    header("Content-Type", "application/json")
    self
  end

  def body
    finish
    @io.to_s
  end

  def response
    finish
    @response
  end

  private def finish
    @response.close
    @io.rewind
  end
end
