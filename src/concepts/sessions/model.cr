class Sessions::Model
  property email : String = ""
  property password : String = ""
  property authenticated : Bool = false
  property token : String = ""
  property user : Users::Model = Users::Model.new

  def authenticated?
    @authenticated
  end
end
