require "crypto/bcrypt/password"

class Sessions::Controller < ApplicationController
  def create
    session = Loader.new(Model.new, params.json).execute
    validator = Validator.new(session).validate

    unless validator.valid?
      response.status_code = 401
      return { error: "Not authenticated", messages: validator.errors }.to_json
    end

    Services::Signin.new(session).authenticate

    unless session.authenticated?
      response.status_code = 401
      return { error: "Not authenticated", messages: ["Token could not be created"] }.to_json
    end

    response.status_code = 201
    { token: session.token }
  end
end
