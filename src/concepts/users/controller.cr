class Users::Controller
  def index(env)
    users = Repository.new.all
    CollectionPresenter.new(users).present
  end

  def show(env)
    user = Repository.new.find(env.params.url["id"].to_i)
    Presenter.new(user).present
  end

  def create(env)
    user = Parser.new(Model.new, env.params.json).execute
    validator = Validator.new(user).validate

    if validator.valid?
      env.response.status_code = 201
      user = Repository.new.create(user)
      Presenter.new(user).present
    else
      env.response.status_code = 422
      return { error: "Failed to create user", errors: validator.errors }.to_json
    end
  end

  def update(env)
    user = Repository.new.find(env.params.url["id"].to_i)
    user = Parser.new(user, env.params.json).execute
    validator = Validator.new(user).validate

    if validator.valid?
      user = Repository.new.update(user)
      Presenter.new(user).present
    else
      env.response.status_code = 422
      return { error: "Failed to update user", errors: validator.errors }.to_json
    end
  end

  def delete(env)
    user = Repository.new.find(env.params.url["id"].to_i)
    Repository.new.delete(user)
    env.response.status_code = 204
  end
end
