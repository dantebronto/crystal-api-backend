alias KemalJSON = Hash(String, Array(JSON::Type) | Bool | Float64 | Hash(String, JSON::Type) | Int64 | String | Nil)

class ApplicationController
  @current_user : Users::Model | Nil

  def initialize(@env : HTTP::Server::Context)
  end

  def params
    @env.params
  end

  def status(code)
    @env.response.status_code = code
  end

  def response
    @env.response
  end

  def error(body, status)
    @env.response.status_code = status
    body.to_json
  end

  def current_user
    @current_user ||= Users::Repository.new.find_by_id(@env.get("uid").to_s)
  end
end
