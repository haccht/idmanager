require 'net/ssh'

class User < ActiveLdap::Base
  include ActiveModel::Model
  ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=users', :classes => ['posixAccount', 'inetOrgPerson', 'ldapPublicKey']

  belongs_to :groups,        class_name: 'Group', primary_key: 'cn', :many => 'memberUid'
  belongs_to :primary_group, class_name: 'Group', foreign_key: 'gidNumber', primary_key: 'gidNumber'

  validate do
    unless ssh_public_key.blank? || system("echo #{ssh_public_key} | ssh-keygen -l -f -")
      errors.add(:ssh_public_key, :invalid_key, message: 'invalid!')
    end

    unless user_password.present? && user_password.length >= 8
      errors.add(:user_password, :too_short, message: 'is too short (must be at least 8 chars).')
    end
  end

  before_validation do
    self.sn   ||= self.cn
    self.uid  ||= self.cn
    self.mail ||= self.cn + '@' + ENV['SESSION_DOMAIN_NAME']
    self.uid_number ||= (User.all.map(&:uid_number).max || 5000) + 1
    self.gid_number ||= Group.all.map(&:gid_number).min || 5000
    self.login_shell    ||= "/bin/bash"
    self.home_directory ||= "/home/#{self.cn}"
  end

  before_save do
    if user_password.present? && user_password !~ /^\{([A-Za-z][A-Za-z\d]+)\}/
      self.user_password = ActiveLdap::UserPassword.ssha(user_password)
    end
    self
  end

  after_save do
    self.primary_group.member_uid += [cn]
    self.primary_group.save!
  end

  def destroy
    self.groups.map do |group|
      group.member_uid -= [cn]
      group.save!
    end
    self.delete_all
  end

  def member_of?(group)
      !!groups.find { |e| e.cn == group }
  end

  def valid_password?(password_confirmation)
    (user_password == password_confirmation).tap do |valid|
      errors.add(:user_password, :unmatch, message: 'didn\'t match with the confirmation.') unless valid
    end
  end

  def to_param
    uid_number.to_s
  end
end
