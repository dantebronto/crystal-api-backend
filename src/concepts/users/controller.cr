class Users::Controller < ApplicationController
  def index
    Policy.new.index?(current_user)
    users = Repository.new.all
    CollectionPresenter.new(users).present
  end

  def show
    user = Repository.new.find(params.url["id"])
    Policy.new.self_or_admin?(current_user, user)
    Presenter.new(user).present
  end

  def create
    user = Loader.new(params.json).execute
    Services::Registration.new(user).execute
    validator = Validator.new(user).validate

    if validator.valid?
      response.status_code = 201
      user = Repository.new.create(user)
      Presenter.new(user).present
    else
      response.status_code = 422
      return { error: "Failed to create user", messages: validator.errors }.to_json
    end
  end

  def update
    user = Repository.new.find(params.url["id"])
    Policy.new.self_or_admin?(current_user, user)
    Loader.new(params.json).set_user(user).execute
    validator = Validator.new(user).validate

    if validator.valid?
      user = Repository.new.update(user)
      Presenter.new(user).present
    else
      response.status_code = 422
      return { error: "Failed to update user", messages: validator.errors }.to_json
    end
  end

  def delete
    user = Repository.new.find(params.url["id"])
    Policy.new.self_or_admin?(current_user, user)
    Repository.new.delete(user)
    response.status_code = 204
  end
end
