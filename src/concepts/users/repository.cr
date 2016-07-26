class Users::Repository
  def all
    Query.from("users").order("created_at DESC").execute.
      map {|x| Model.from_sql(x) }
  end

  def find(uuid)
    results = Query.from("users").where("uuid = ?", uuid).limit(1).execute
    raise RecordNotFound.new if results.size == 0
    Model.from_sql(results.first)
  end

  def create(user)
    results = Query.
      insert({
        "email" => user.email,
        "uuid" => user.uuid,
        "encrypted_password" => user.encrypted_password,
        "name" => user.name,
        "created_at" => Time.now,
        "updated_at" => Time.now
      }).
      into("users").
      execute
    Model.from_sql(results.first)
  end

  def update(user)
    results = Query.
      update("users", {
        "name" => user.name,
        "email" => user.email,
        "updated_at" => Time.now,
      }).
      where("id = ?", user.id.to_s).
      execute
    Model.from_sql(results.first)
  end

  def delete(user)
    Query.delete.from("users").where("uuid = ?", user.uuid.to_s).execute
  end

  def email_unique?(user)
    query = Query.select("email").from("users").where("email = ?", user.email.to_s)
    query.where("id != ?", user.id.to_s) if user.id
    query.limit(1).count == 0
  end

  def name_unique?(user)
    query = Query.select("name").from("users").where("name = ?", user.name.to_s)
    query.where("id != ?", user.id.to_s) if user.id
    query.limit(1).count == 0
  end

  def find_for_auth(email)
    results = Query.from("users").where("email = ?", email.to_s).limit(1).execute
    results.size == 0 ? Model.new : Model.from_sql(results.first)
  end
end
