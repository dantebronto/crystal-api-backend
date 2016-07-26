class Sessions::Loader
  def initialize(@session : Model, @body : KemalJSON)
  end

  def execute
    {% for field in ["email", "password"] %}
      @session.{{field.id}} = (@body[{{field}}].to_s).strip if @body.has_key?({{field}})
    {% end %}
    @session
  end
end