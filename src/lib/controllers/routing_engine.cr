ROUTES = [] of Route

class Route
  getter :action, :path, :verb
  # property visibility : String = "authenticated"
  def initialize(@verb : String, @path : String, @action : String)
    ROUTES << self
  end
end

class Router
  macro head(path, action)
    {% split = action.split("#") %}
    Kemal::RouteHandler::INSTANCE.add_route("HEAD", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
    end
    Route.new("HEAD", {{path}}, {{action}})
  end
  macro get(path, action)
    {% split = action.split("#") %}
    Kemal::RouteHandler::INSTANCE.add_route("GET", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
    end
    Route.new("GET", {{path}}, {{action}})
  end
  macro post(path, action)
    {% split = action.split("#") %}
    Kemal::RouteHandler::INSTANCE.add_route("POST", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
    end
    Route.new("POST", {{path}}, {{action}})
  end
  macro put(path, action)
    {% split = action.split("#") %}
    Kemal::RouteHandler::INSTANCE.add_route("PUT", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
    end
    Route.new("PUT", {{path}}, {{action}})
  end
  macro patch(path, action)
    {% split = action.split("#") %}
    Kemal::RouteHandler::INSTANCE.add_route("PATCH", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
    end
    Route.new("PATCH", {{path}}, {{action}})
  end
  macro delete(path, action)
    {% split = action.split("#") %}
    Kemal::RouteHandler::INSTANCE.add_route("DELETE", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
    end
    Route.new("DELETE", {{path}}, {{action}})
  end
  macro match(verb, path, action)
    {% split = action.split("#") %}
    Kemal::RouteHandler::INSTANCE.add_route({{verb}}, {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
    end
    Route.new({{verb}}, {{path}}, {{action}})
  end
  def self.draw
    with self yield
  end
end