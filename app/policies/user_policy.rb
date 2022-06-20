class UserPolicy < ApplicationPolicy

  def index?
    user.member_of?('admin')
  end

  def show?
    user.member_of?('admin') || user.uid_number == record.uid_number
  end

  def new?
    true
  end

  def edit?
    user.member_of?('admin') || user.uid_number == record.uid_number
  end

  def edit_password?
    edit?
  end

  def update_password?
    edit?
  end

end
