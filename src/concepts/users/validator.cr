class Users::Validator
  getter errors : Array(String) = [] of String

  def initialize(@user : Users::Model)
  end

  def validate
    @errors << "name can't be blank" if @user.name.nil? || @user.name == ""
    self
  end

  def valid?
    @errors.size == 0
  end
end