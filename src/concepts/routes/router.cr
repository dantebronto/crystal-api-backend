module Routes
  class Router
    ROUTES = [] of Routes::Model

    macro head(path, action)
      {% split = action.split("#") %}
      Kemal::RouteHandler::INSTANCE.add_route("HEAD", {{path}}) do |env|
        {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
      end
      Routes::Model.new("HEAD", {{path}}, {{action}})
    end

    macro get(path, action)
      {% split = action.split("#") %}
      Kemal::RouteHandler::INSTANCE.add_route("GET", {{path}}) do |env|
        {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
      end
      Routes::Model.new("GET", {{path}}, {{action}})
    end

    macro post(path, action)
      {% split = action.split("#") %}
      Kemal::RouteHandler::INSTANCE.add_route("POST", {{path}}) do |env|
        {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
      end
      Routes::Model.new("POST", {{path}}, {{action}})
    end

    macro put(path, action)
      {% split = action.split("#") %}
      Kemal::RouteHandler::INSTANCE.add_route("PUT", {{path}}) do |env|
        {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
      end
      Routes::Model.new("PUT", {{path}}, {{action}})
    end

    macro patch(path, action)
      {% split = action.split("#") %}
      Kemal::RouteHandler::INSTANCE.add_route("PATCH", {{path}}) do |env|
        {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
      end
      Routes::Model.new("PATCH", {{path}}, {{action}})
    end

    macro delete(path, action)
      {% split = action.split("#") %}
      Kemal::RouteHandler::INSTANCE.add_route("DELETE", {{path}}) do |env|
        {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
      end
      Routes::Model.new("DELETE", {{path}}, {{action}})
    end

    macro match(verb, path, action)
      {% split = action.split("#") %}
      Kemal::RouteHandler::INSTANCE.add_route({{verb}}, {{path}}) do |env|
        {{split.first.id.capitalize}}::Controller.new(env).{{split.last.id}}
      end
      Routes::Model.new({{verb}}, {{path}}, {{action}})
    end

    def self.draw
      with self yield
    end
  end
end
