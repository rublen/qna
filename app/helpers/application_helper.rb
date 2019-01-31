module ApplicationHelper
  include Pagy::Frontend

  def current_user_role(obj)
    return "guest" unless current_user
    return "author" if (current_user.author_of?(obj) && !current_user.admin?)

    role = current_user.admin? ? "admin" : "other"

    return role + "/not_voted" unless obj.voted?(current_user)
    role + (obj.upvoted?(current_user) ? "/upvoted" : "/downvoted")
  end
end
