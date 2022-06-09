class User < ActiveLdap::Base
  include ActiveModel::Model
  ldap_mapping :dn_attribute => 'uidNumber', :prefix => 'ou=users', :classes => ['posixAccount','account']
  belongs_to :groups,        class_name: 'Group', foreign_key: 'uid', :many => 'memberUid'
  belongs_to :primary_group, class_name: 'Group', foreign_key: 'gidNumber', primary_key: 'gidNumber'
end
