class Users::Model
  property id : Int32?
  property name : String?
  property uuid : String?
  property email : String?
  property password : String?
  property encrypted_password : String?
  property created_at : Int64?
  property updated_at : Int64?
  property admin : Bool = false

  extend BuildFromSQL

  def admin?
    @admin
  end
end
