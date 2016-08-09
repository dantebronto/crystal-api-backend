class Routes::Presenter
  def initialize(@subject : Array(Routes::Model), @role : Symbol? = nil)
  end

  include PresenterHelpers

  def present
    keyed_array("routes") do |a, io|
      @subject.each do |route|
        a.push do
          io.json_object do |json_route|
            {% for prop in ["verb", "path", "action"] %}
              json_route.field {{prop}}, route.{{prop.id}}
            {% end %}
          end
        end
      end
    end
  end
end
