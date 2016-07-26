class JSONContentType < HTTP::Handler
  def call(env)
    env.response.content_type = "application/json"
    unless json_request?(env)
      env.response.status_code = 422
      return env.response.print({
        error: "Non-JSON request",
        messages: ["Content-Type header must be set to application/json"]
      }.to_json)
    end
    call_next env
  end

  private def json_request?(env)
    env.request.headers.has_key?("Content-Type") && env.request.headers["Content-Type"] == "application/json"
  end
end