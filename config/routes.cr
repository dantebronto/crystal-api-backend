require "../src/app/controllers/*"
require "./routing_engine"

Router.draw do
  get "/api/users", "users#index"

  get  "/api/widgets",     "widgets#index"
  post "/api/widgets",     "widgets#create"
  get  "/api/widgets/:id", "widgets#show"
end
