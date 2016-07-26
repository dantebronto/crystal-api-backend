class Users::Loader
  def initialize(@body : KemalJSON)
    @user = Model.new
  end

  def set_user(user)
    @user = user
    self
  end

  def execute
    {% for field in ["name", "email", "password"] %}
      @user.{{field.id}} = (@body[{{field}}].to_s).strip if @body.has_key?({{field}})
    {% end %}
    @user
  end
end