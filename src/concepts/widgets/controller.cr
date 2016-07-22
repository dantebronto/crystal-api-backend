class Widgets::Controller
  def index(env)
    env.response.content_type = "application/json"
    [
      { name: "Alice", age: 20 },
      { name: "Bob", age: 25 },
      { name: "Chuck", age: 33 }
    ].to_json
  end

  def create(env)
    "hello from widgets#create"
  end

  def show(env)
    "hello from widgets#show"
  end
end