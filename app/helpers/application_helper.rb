module ApplicationHelper
  include Pagy::Frontend

  def current_user_role(obj)
    return "guest" unless current_user
    return "admin" if current_user.admin?
    current_user.author_of?(obj) ? "author" : "other"
  end
end
