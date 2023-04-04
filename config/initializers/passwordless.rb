require 'socket'

hostname = Addrinfo.getaddrinfo(Socket.gethostname, nil).first.getnameinfo.first
Passwordless.default_from_address = "no-reply@#{ENV.fetch('RAILS_SMTP_DOMAIN', hostname)}"

Passwordless.restrict_token_reuse = true
Passwordless.expires_at = lambda { ENV.fetch('PASSWORDLESS_EXPIRES_AT', 1).to_i.day.from_now }
Passwordless.timeout_at = lambda { ENV.fetch('PASSWORDLESS_TIMEOUT_AT', 1).to_i.hour.from_now }

Passwordless.success_redirect_path  = ENV['RAILS_RELATIVE_URL_ROOT'] || '/'
Passwordless.failure_redirect_path  = ENV['RAILS_RELATIVE_URL_ROOT'] || '/'
Passwordless.sign_out_redirect_path = ENV['RAILS_RELATIVE_URL_ROOT'] || '/'
