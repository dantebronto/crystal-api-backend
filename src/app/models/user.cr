require "kemalyst-model/adapter/pg"

class User < Kemalyst::Model
  adapter pg

  def to_json(io)
    io.json_object do |obj|
      obj.field "id", id
      obj.field "name", name
      obj.field "created_at", created_at.to_s
      obj.field "updated_at", updated_at.to_s
    end
  end

  def self.build(hash)
    user = User.new
    user.name = hash["name"] as String
    user
  end

  sql_mapping({
    name: ["VARCHAR(255)", String]
  })
end
