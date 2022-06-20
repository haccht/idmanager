class GroupPolicy < ApplicationPolicy

  def index?
    user.member_of?('admin')
  end

  def show?
    user.member_of?('admin')
  end

  def new?
    user.member_of?('admin')
  end

  def edit?
    user.member_of?('admin')
  end

end
