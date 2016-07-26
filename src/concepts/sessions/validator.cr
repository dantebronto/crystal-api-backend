class Sessions::Validator
  getter errors : Array(String) = [] of String

  def initialize(@session : Model)
  end

  def validate
    @errors << "email can't be blank" if @session.email.to_s == ""
    @errors << "password can't be blank" if @session.password.to_s == ""
    self
  end

  def valid?
    @errors.size == 0
  end
end