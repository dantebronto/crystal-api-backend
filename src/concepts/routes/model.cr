module Routes
  class Model
    getter :action, :path, :verb

    def initialize(@verb : String, @path : String, @action : String)
      Router::ROUTES << self
    end
  end
end
