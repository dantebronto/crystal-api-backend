Router.draw do
  post "/api/sessions", "sessions#create"

  get    "/api/users",     "users#index"
  post   "/api/users",     "users#create"
  get    "/api/users/:id", "users#show"
  put    "/api/users/:id", "users#update"
  delete "/api/users/:id", "users#delete"

  get  "/api/widgets",     "widgets#index"
  post "/api/widgets",     "widgets#create"
  get  "/api/widgets/:id", "widgets#show"

  get "/api/routes", "routes#index"
end
