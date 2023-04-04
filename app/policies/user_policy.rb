class UserPolicy < ApplicationPolicy

  def index?
    Group.admins.include?(user)
  end

  def show?
    edit?
  end

  def new?
    true
  end

  def edit?
    Group.admins.include?(user) || user.uid_number == record.uid_number
  end

  def edit_password?
    edit?
  end

  def update_password?
    edit?
  end

end
