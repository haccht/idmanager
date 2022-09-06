Passwordless.restrict_token_reuse = true
Passwordless.default_from_address = "no-reply@#{ENV['RAILS_SMTP_DOMAIN']}"
Passwordless.expires_at = lambda { ENV['PASSWORDLESS_EXPIRES_AT'].to_i.hour.from_now }
Passwordless.timeout_at = lambda { ENV['PASSWORDLESS_TIMEOUT_AT'].to_i.hour.from_now }
