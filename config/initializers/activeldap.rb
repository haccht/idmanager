require 'active_ldap'

ActiveLdap::Base.setup_connection(
  host: ENV.fetch('LDAP_HOST', 'localhost'),
  port: ENV.fetch('LDAP_PORT', 636),
  base:     ENV.fetch('LDAP_BASE_DN', 'dc=example,dc=com'),
  bind_dn:  ENV.fetch('LDAP_BIND_DN', 'cn=admin,dc=example,dc=com'),
  password: ENV.fetch('LDAP_BIND_PW', 'admin'),
  method: :ssl,
  tls_options: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
)
