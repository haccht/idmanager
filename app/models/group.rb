class Group < ActiveLdap::Base
  include ActiveModel::Model
  ldap_mapping dn_attribute: 'cn', prefix: 'ou=groups', classes: ['posixGroup']

  has_many :primary_members, class_name: 'User', foreign_key: 'gidNumber', primary_key: 'gidNumber'
  has_many :members,         class_name: 'User', primary_key: 'cn', wrap: 'memberUid'

  def self.admin
    unless group = Group.first('admin')
      group = Group.new
      group.update_attributes(cn: 'admin',  gid_number: self.gid_next)
      group.save!
    end
    return group
  end

  def self.member
    unless group = Group.first('member')
      group = Group.new
      group.update_attributes(cn: 'member', gid_number: self.gid_next)
      group.save!
    end
    return group
  end

  def self.gid_next
    self.all.map(&:gid_number).max&.+1 or 5000
  end

  def append(user)
    self.member_uid = [*self.member_uid, user.uid]
    self.save!
  end

  def remove(user)
    self.member_uid = [*self.member_uid] - [user.uid]
    self.save!
  end

  def member?(user)
    self.member_uid.present? && self.member_uid.include?(user.uid)
  end

  def destroy
    self.delete_all
  end

  def to_param
    gid_number.to_s
  end
end
