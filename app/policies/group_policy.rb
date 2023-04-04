class GroupPolicy < ApplicationPolicy

  def index?
    Group.admins.include?(user)
  end

  def show?
    Group.admins.include?(user)
  end

  def new?
    Group.admins.include?(user)
  end

  def edit?
    Group.admins.include?(user)
  end

end
