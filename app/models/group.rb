class Group < ActiveLdap::Base
  include ActiveModel::Model
  ldap_mapping dn_attribute: 'cn', prefix: 'ou=groups', classes: ['posixGroup', 'groupOfNames']

  has_many :users, class_name: 'User', wrap: 'member', primary_key: 'dn'
  has_many :primary_users, class_name: 'User', foreign_key: 'gidNumber', primary_key: 'gidNumber'

  def self.admin
    unless group = Group.first('administrator')
      group = Group.new
      group.update_attributes(cn: 'administrator',  gid_number: self.gid_next)
    end
    return group
  end

  def self.member
    unless group = Group.first('member')
      group = Group.new
      group.update_attributes(cn: 'member', gid_number: self.gid_next)
    end
    return group
  end

  def self.gid_next
    self.all.map(&:gid_number).max&.+1 or 5000
  end

  def reserved?
    Group.admin == self || Group.member == self
  end

  def append(user)
    return if self.member?(user)

    self.member = [*self.member] + [user.dn]
    self.save!
  end

  def remove(user)
    return unless self.member?(user)
    return destroy if self.member.size == 1

    self.member = [*self.member] - [user.dn]
    self.save!
  end

  def member?(user)
    [*self.member].include?(user.dn)
  end

  def destroy
    self.delete_all
  end

  def to_param
    gid_number.to_s
  end
end
