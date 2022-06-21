class UserPolicy < ApplicationPolicy

  def index?
    Group.admin.member?(user)
  end

  def show?
    Group.admin.member?(user) || user.uid_number == record.uid_number
  end

  def new?
    true
  end

  def edit?
    Group.admin.member?(user) || user.uid_number == record.uid_number
  end

  def edit_password?
    edit?
  end

  def update_password?
    edit?
  end

end
