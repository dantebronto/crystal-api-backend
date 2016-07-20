require "../models/user"

class UsersController
  def index(env)
    env.response.content_type = "application/json"
    [
      { name: "Alice", age: 20 },
      { name: "Bob", age: 25 },
      { name: "Chuck", age: 33 }
    ].to_json
  end
end
