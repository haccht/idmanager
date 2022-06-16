Passwordless.default_from_address = "CHANGE_ME@example.com"
Passwordless.restrict_token_reuse = true

Passwordless.expires_at = lambda { 3.day.from_now }
Passwordless.timeout_at = lambda { 1.hour.from_now }
