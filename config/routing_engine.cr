ROUTES = [] of Route

class Route
  getter :action, :path, :verb
  def initialize(@verb : String, @path : String, @action : String)
    ROUTES << self
  end
end

class Router
  macro head(path, action)
    {% split = action.split("#") %}
    Route.new("HEAD", {{path}}, {{action}})
    Kemal::RouteHandler::INSTANCE.add_route("HEAD", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new.{{split.last.id}}(env)
    end
  end
  macro get(path, action)
    {% split = action.split("#") %}
    Route.new("GET", {{path}}, {{action}})
    Kemal::RouteHandler::INSTANCE.add_route("GET", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new.{{split.last.id}}(env)
    end
  end
  macro post(path, action)
    {% split = action.split("#") %}
    Route.new("POST", {{path}}, {{action}})
    Kemal::RouteHandler::INSTANCE.add_route("POST", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new.{{split.last.id}}(env)
    end
  end
  macro put(path, action)
    {% split = action.split("#") %}
    Route.new("PUT", {{path}}, {{action}})
    Kemal::RouteHandler::INSTANCE.add_route("PUT", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new.{{split.last.id}}(env)
    end
  end
  macro patch(path, action)
    {% split = action.split("#") %}
    Route.new("PATCH", {{path}}, {{action}})
    Kemal::RouteHandler::INSTANCE.add_route("PATCH", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new.{{split.last.id}}(env)
    end
  end
  macro delete(path, action)
    {% split = action.split("#") %}
    Route.new("DELETE", {{path}}, {{action}})
    Kemal::RouteHandler::INSTANCE.add_route("DELETE", {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new.{{split.last.id}}(env)
    end
  end
  macro match(verb, path, action)
    {% split = action.split("#") %}
    Route.new({{verb}}, {{path}}, {{action}})
    Kemal::RouteHandler::INSTANCE.add_route({{verb}}, {{path}}) do |env|
      {{split.first.id.capitalize}}::Controller.new.{{split.last.id}}(env)
    end
  end
  def self.draw
    with self yield
  end
end