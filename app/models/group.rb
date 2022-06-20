class Group < ActiveLdap::Base
  include ActiveModel::Model
  ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=groups', :classes => ['posixGroup']

  has_many :primary_members, class_name: 'User', foreign_key: 'gidNumber', primary_key: 'gidNumber'
  has_many :members,         class_name: 'User', primary_key: 'cn', wrap: 'memberUid'

  def self.gid_next
    self.all.map(&:gid_number).max&.+1 || 5000
  end

  def destroy
    self.delete_all
  end

  def to_param
    gid_number.to_s
  end
end
