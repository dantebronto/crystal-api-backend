require "secure_random"

class Sessions::Services::Signin
  def initialize(@session : Model)
  end

  def authenticate
    @session.tap do |s|
      s.user = load_user
      s.authenticated = stored_pass == s.password.to_s
      s.password = ""
      return s unless s.authenticated
      s.token = generate_token
    end
  end

  private def stored_pass
    if @session.user.encrypted_password.to_s == ""
      Crypto::Bcrypt::Password.create(SecureRandom.hex)
    else
      Crypto::Bcrypt::Password.new(@session.user.encrypted_password.to_s)
    end
  end

  private def load_user
    Users::Repository.new.find_for_auth(@session.email)
  end

  private def generate_token
    payload = {"uid" => @session.user.id, "nonce" => Time.now.epoch.to_s}
    JWT.encode(payload, ENV["SESSION_SECRET"], "HS256")
  end
end
