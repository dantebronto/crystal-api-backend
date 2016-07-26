class Users::Model
  property id : Int32 | Nil
  property name : String | Nil
  property uuid : String | Nil
  property email : String | Nil
  property password : String | Nil
  property encrypted_password : String | Nil
  property created_at : Int64 | Nil
  property updated_at : Int64 | Nil
  property admin : Bool = false

  extend BuildFromSQL

  def admin?
    @admin
  end
end
