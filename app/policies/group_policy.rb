class GroupPolicy < ApplicationPolicy

  def index?
    # not implemented
    false && user.member_of?('wheel')
  end

  def show?
    # not implemented
    false && user.member_of?('wheel')
  end

  def new?
    # not implemented
    false && user.member_of?('wheel')
  end

  def edit?
    # not implemented
    false && user.member_of?('wheel')
  end

end
