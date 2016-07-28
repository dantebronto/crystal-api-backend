class Users::Fixture
  def self.admin
    admin = Model.new.tap do |u|
      u.name = "admin"
      u.email = "admin@example.com"
      u.password = "changeme"
    end

    admin.uuid = UUID.generate
    admin.encrypted_password = UUID.generate

    Repository.new.create(admin)
    Query.update("users", { "admin" => true } of String => InsertType).
      where("name = ?", admin.name.to_s).execute
    Repository.new.find_for_auth(admin.email)
  end

  def self.user
    user = Model.new.tap do |u|
      u.name = "user"
      u.email = "user@example.com"
      u.password = "changeme"
    end

    user.uuid = UUID.generate
    user.encrypted_password = UUID.generate

    Repository.new.create(user)
    Repository.new.find_for_auth(user.email)
  end

  def self.other_user
    user = Model.new.tap do |u|
      u.name = "user2"
      u.email = "user2@example.com"
      u.password = "changeme"
    end

    user.uuid = UUID.generate
    user.encrypted_password = UUID.generate

    Repository.new.create(user)
    Repository.new.find_for_auth(user.email)
  end
end

class Users::Services::Registration
  private def encrypt_password
    @user.encrypted_password = "hashing is slow"
  end
end
