class Routes::Controller < ApplicationController
  @@response : String | Nil

  def index
    @@response ||= Routes::Presenter.new(ROUTES).present
  end
end