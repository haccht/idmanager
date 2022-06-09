class Group < ActiveLdap::Base
  include ActiveModel::Model
  ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=groups', :classes => ['posixGroup']
  has_many :primary_members, class_name: 'User', foreign_key: 'gidNumber', primary_key: 'gidNumber'
  has_many :members,         class_name: "User", primary_key: 'uid', wrap: "memberUid"
end
