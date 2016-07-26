class Users::Validator
  getter errors : Array(String) = [] of String

  def initialize(@user : Users::Model)
  end

  def validate
    validate_password
    validate_presence
    validate_uniqueness
    self
  end

  def validate_presence
    @errors << "name can't be blank" if @user.name.to_s == ""
    @errors << "email can't be blank" if @user.email.to_s == ""
    @errors << "uuid can't be blank" if @user.uuid.to_s == ""
  end

  def validate_uniqueness
    repo = Repository.new
    @errors << "email has already been taken" unless repo.email_unique?(@user)
    @errors << "name has already been taken" unless repo.name_unique?(@user)
  end

  def validate_password
    @errors << "password can't be blank" if @user.encrypted_password.nil? || @user.encrypted_password == ""
    if @user.password
      @errors << "password is too short (should be 6 characters minimum)" if @user.password.to_s.size < 6
    end
  end

  def valid?
    @errors.size == 0
  end
end