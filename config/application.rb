require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Idmanager2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = 'Asia/Tokyo'
    config.hosts << ENV.fetch('RAILS_HOST', 'localhost')

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = {
      host:        ENV.fetch('RAILS_HOST', 'localhost'),
      script_name: File.join(ENV.fetch('RAILS_RELATIVE_URL_ROOT', '/'), '/'),
      only_path:   false,
    }
    config.action_mailer.smtp_settings = {
      address:        ENV.fetch('RAILS_SMTP_ADDRESS', 'localhost'),
      port:           ENV.fetch('RAILS_SMTP_PORT', 25),
      authentication: false,
    }
  end
end
