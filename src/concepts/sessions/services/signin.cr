require "secure_random"

class Sessions::Services::Signin
  def initialize(@session : Model)
  end

  def authenticate
    load_user
    @session.authenticated = stored_pass == @session.password.to_s
    generate_token
    @session.password = ""
    @session
  end

  private def stored_pass
    if @session.user.encrypted_password.to_s == ""
      Crypto::Bcrypt::Password.create(SecureRandom.hex)
    else
      Crypto::Bcrypt::Password.new(@session.user.encrypted_password.to_s)
    end
  end

  private def load_user
    @session.user = Users::Repository.new.find_for_auth(@session.email)
  end

  private def generate_token
    payload = { "uid" => @session.user.id, "nonce" => Time.now.epoch.to_s }
    @session.token = JWT.encode(payload, ENV["SESSION_SECRET"], "HS256")
  end
end