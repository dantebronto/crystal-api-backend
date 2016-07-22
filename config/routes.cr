Router.draw do
  get    "/api/users",     "users#index"
  get    "/api/users/:id", "users#show"
  post   "/api/users",     "users#create"
  put    "/api/users/:id", "users#update"
  delete "/api/users/:id", "users#delete"

  get  "/api/widgets",     "widgets#index"
  post "/api/widgets",     "widgets#create"
  get  "/api/widgets/:id", "widgets#show"

  get "/api/routes", "routes#index"
end
