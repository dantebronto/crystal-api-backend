class JSONContentType < HTTP::Handler
  def call(env)
    env.response.content_type = "application/json"
    call_next env
  end
end