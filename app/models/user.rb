class User < ActiveLdap::Base
  include ActiveModel::Model
  ldap_mapping dn_attribute: 'uid', prefix: 'ou=users', classes: ['posixAccount', 'inetOrgPerson']

  belongs_to :groups, class_name: 'Group', many: 'uniqueMember', foreign_key: 'dn'
  belongs_to :primary_group, class_name: 'Group', foreign_key: 'gidNumber', primary_key: 'gidNumber'

  validates :user_password, presence: true, length: { minimum: 8 }, allow_nil: true, confirmation: true
  validates :user_password_confirmation, presence: true

  before_save do
    self.user_password = ActiveLdap::UserPassword.ssha(user_password) if user_password.present?
  end

  after_create do
    Serial.increment_uid

    Group.users.append(self)
    Group.admins.append(self) if User.count == 1
  end

  def belongs_to?(group)
    group = Group.first(cn: group)
    return !group.nil? && group.include?(self)
  end

  def destroy
    self.delete_all
  end

  def to_param
    uid_number.to_s
  end
end
