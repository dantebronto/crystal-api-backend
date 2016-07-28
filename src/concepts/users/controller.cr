class Users::Controller < ApplicationController
  def index
    Policy.new(current_user).admin?
    users = Repository.new.all
    CollectionPresenter.new(users).present
  end

  def show
    user = Repository.new.find(params.url["id"])
    Policy.new(current_user).admin?
    Presenter.new(user).present
  end

  def create
    user = Loader.new(params.json).execute
    Services::Registration.new(user).execute
    validator = Validator.new(user).validate

    if validator.valid?
      user = Repository.new.create(user)
      status 201
      Presenter.new(user).present
    else
      error({ error: "Failed to create user", messages: validator.errors }, status: 422)
    end
  end

  def update
    user = Repository.new.find(params.url["id"])
    Policy.new(current_user).self_or_admin?(user)
    Loader.new(params.json).set_user(user).execute
    validator = Validator.new(user).validate

    if validator.valid?
      user = Repository.new.update(user)
      Presenter.new(user).present
    else
      error({ error: "Failed to update user", messages: validator.errors }, status: 422)
    end
  end

  def delete
    user = Repository.new.find(params.url["id"])
    Policy.new(current_user).self_or_admin?(user).self_is_admin?(user)
    Repository.new.delete(user)
    status 204
  end
end
