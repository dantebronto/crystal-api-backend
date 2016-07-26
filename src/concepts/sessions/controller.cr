require "crypto/bcrypt/password"

class Sessions::Controller
  def create(env)
    session = Loader.new(Model.new, env.params.json).execute
    validator = Validator.new(session).validate

    unless validator.valid?
      env.response.status_code = 401
      return { error: "Not authenticated", messages: validator.errors }.to_json
    end

    Services::Signin.new(session).authenticate

    unless session.authenticated?
      env.response.status_code = 401
      return { error: "Not authenticated", messages: ["Token could not be created"] }.to_json
    end

    env.response.status_code = 201
    { token: session.token }
  end
end
