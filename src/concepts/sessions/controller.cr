require "crypto/bcrypt/password"

class Sessions::Controller < ApplicationController
  def create
    session = Loader.new(Model.new, params.json).execute
    validator = Validator.new(session).validate

    unless validator.valid?
      return error({
        error: "Not authenticated",
        messages: validator.errors
      }, status: 401)
    end

    Services::Signin.new(session).authenticate

    unless session.authenticated?
      return error({
        error: "Not authenticated",
        messages: ["Token could not be created"]
      }, 401)
    end

   status 201
    { token: session.token }.to_json
  end
end
