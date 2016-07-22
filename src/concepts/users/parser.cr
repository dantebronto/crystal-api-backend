class Users::Parser
  @body : Hash(String, Array(JSON::Type) | Bool | Float64 | Hash(String, JSON::Type) | Int64 | String | Nil)
  @user : Model

  def initialize(@user, @body)
  end

  def execute
    @user.name = (@body["name"] as String).strip if @body.has_key?("name")
    @user
  end
end