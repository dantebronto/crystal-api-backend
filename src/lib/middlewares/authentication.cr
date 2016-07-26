class Authentication < HTTP::Handler
  def call(env)
    return call_next(env) if env.request.path == "/api/sessions"
    return call_next(env) if env.request.path == "/api/users" && env.request.method == "POST"

    env.response.content_type = "application/json"
    begin
      # Authorization: Bearer <token>
      token = env.request.headers["Authorization"].sub("Bearer ", "")
      payload = JWT.decode(token, ENV["SESSION_SECRET"], "HS256")
      env.set("uid", payload.first["uid"].to_s)
      call_next env
    rescue KeyError
      env.response.status_code = 401
      env.response.print({ error: "Authentication header not found" }.to_json)
    rescue JWT::VerificationError
      env.response.status_code = 401
      env.response.print({ error: "Verification error", messages: ["Token not valid"] }.to_json)
    end
  end
end