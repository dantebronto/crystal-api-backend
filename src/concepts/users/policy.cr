class Users::Policy
  def index?(user)
    raise Unauthorized.new unless user.admin?
  end

  def self_or_admin?(current_user, user)
    raise Unauthorized.new unless current_user.admin? || current_user == user
  end
end