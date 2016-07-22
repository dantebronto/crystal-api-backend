class Routes::Presenter
  def initialize(@subject : Array(::Route), @role : Symbol | Nil = nil)
  end

  def present
    String.build do |io|
      io.json_object do |obj|
        obj.field "routes", do
          io.json_array do |a|
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
    end
  end
end
