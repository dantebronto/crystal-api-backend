class Routes::Controller
  @@response : String | Nil

  def index(env)
    @@response ||= Routes::Presenter.new(ROUTES).present
  end
end