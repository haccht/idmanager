class GroupPolicy < ApplicationPolicy

  def index?
    Group.admin.member?(user)
  end

  def show?
    Group.admin.member?(user)
  end

  def new?
    Group.admin.member?(user)
  end

  def edit?
    Group.admin.member?(user)
  end

end
