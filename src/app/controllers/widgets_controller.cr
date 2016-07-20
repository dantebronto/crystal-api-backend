class WidgetsController
  def index(env)
    env.response.content_type = "application/json"
    puts User.all.inspect
    User.all.to_json
  end

  def create(env)
    user = User.build(env.params.json)
    user.save
    user.to_json
  end

  def show(env)
    "hello from widgets#show"
  end
end
