class Widgets::Controller < ApplicationController
  def index
    response.content_type = "application/json"
    [
      { name: "Alice", age: 20 },
      { name: "Bob", age: 25 },
      { name: "Chuck", age: 33 }
    ].to_json
  end

  def create
    "hello from widgets#create"
  end

  def show
    "hello from widgets#show"
  end
end