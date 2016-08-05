class Users::CollectionPresenter
  def initialize(@subject : Array(Users::Model), @role : Symbol? = nil)
  end

  include PresenterHelpers

  def present
    keyed_array("users") do |a, io|
      @subject.each do |user|
        a.push { Users::Presenter.new(user, @role).full_object(io) }
      end
    end
  end
end

class Users::Presenter
  def initialize(@subject : Users::Model, @role : Symbol? = nil)
  end

  def present
    String.build { |io| full_object(io) }
  end

  def full_object(io)
    io.json_object do |obj|
      obj.field "id", @subject.uuid
      {% for prop in ["email", "name", "created_at", "updated_at"] %}
        obj.field {{prop}}, @subject.{{prop.id}}
      {% end %}
    end
  end
end
