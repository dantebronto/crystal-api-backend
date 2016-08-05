require "crypto/bcrypt/password"

class Sessions::Controller < ApplicationController
  def create
    session = Loader.new(Model.new, params.json).execute
    validator = Validator.new(session).validate

    return error({
      error:    "Not authenticated",
      messages: validator.errors,
    }, status: 401) unless validator.valid?

    Services::Signin.new(session).authenticate

    return error({
      error:    "Not authenticated",
      messages: ["Token could not be created"],
    }, status: 401) unless session.authenticated?

    status 201
    {token: session.token}.to_json
  end
end
