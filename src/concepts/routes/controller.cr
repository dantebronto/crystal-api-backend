class Routes::Controller < ApplicationController
  @@response : String?

  def index
    @@response ||= Routes::Presenter.new(ROUTES).present
  end
end