module ApplicationHelper
  def can_edit_child_content?(child)
    current_user.parent? || child.shared_with?(current_user)
  end
end