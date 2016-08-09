class Routes::Controller < ApplicationController
  @@response : String?

  def index
    @@response ||= Routes::Presenter.new(Router::ROUTES).present
  end
end
