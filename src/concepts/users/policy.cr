class Users::Policy
  def initialize(@current_user : Model)
  end

  def admin?
    raise Unauthorized.new unless @current_user.admin?
  end

  def self_or_admin?(user)
    raise Unauthorized.new unless @current_user.admin? || @current_user.id == user.id
    self
  end

  def self_is_admin?(user)
    if @current_user.admin? && @current_user.id == user.id
      raise Unauthorized.new("admins can't delete themselves")
    end
    self
  end
end
