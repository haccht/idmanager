class Group < ActiveLdap::Base
  include ActiveModel::Model
  ldap_mapping dn_attribute: 'cn', prefix: 'ou=groups', classes: ['posixGroup', 'groupOfUniqueNames']

  has_many :users, class_name: 'User', wrap: 'uniqueMember', primary_key: 'dn'
  has_many :primary_users, class_name: 'User', foreign_key: 'gidNumber', primary_key: 'gidNumber'

  after_create do
    Serial.increment_gid
  end

  def self.admins
    unless group = Group.first('admins')
      group = Group.new
      group.update_attributes(cn: 'admins', gid_number: Serial.next_gid)
    end
    return group
  end

  def self.users
    unless group = Group.first('users')
      group = Group.new
      group.update_attributes(cn: 'users', gid_number:  Serial.next_gid)
    end
    return group
  end

  def append(user)
    return if self.include?(user)

    members = self.unique_member(true)
    members.append(user.dn.to_s)
    self.unique_member = members

    self.save!
  end

  def remove(user)
    return unless self.include?(user)

    members = self.unique_member(true)
    members.delete(user.dn.to_s)
    self.unique_member = members

    self.save!
  end

  def include?(user)
    members = self.unique_member(true)
    members.include?(user.dn.to_s)
  end

  def destroy
    self.delete_all
  end

  def to_param
    gid_number.to_s
  end
end
