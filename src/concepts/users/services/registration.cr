require "crypto/bcrypt/password"
require "uuid"

class Users::Services::Registration
  @user : Model = Model.new

  def initialize(@user)
  end

  def execute
    generate_uuid
    return @user unless @user.password
    encrypt_password
    @user
  end

  private def encrypt_password
    @user.encrypted_password = Crypto::Bcrypt::Password.create(@user.password.to_s).to_s
  end

  private def generate_uuid
    @user.uuid = UUID.generate
  end
end
