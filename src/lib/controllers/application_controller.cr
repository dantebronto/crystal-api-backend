class ApplicationController

  @current_user : Users::Model | Nil

  def initialize(@env : HTTP::Server::Context)
  end

  def params
    @env.params
  end

  def response
    @env.response
  end

  def current_user
    @current_user ||= Users::Repository.new.find_by_id(@env.get("uid").to_s)
  end
end