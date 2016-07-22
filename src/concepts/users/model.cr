class Users::Model
  property id : Int32 | Nil
  property name : String | Nil
  property created_at : Int64 | Nil
  property updated_at : Int64 | Nil

  extend BuildFromSQL
end
