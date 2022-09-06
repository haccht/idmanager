require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Idmanager
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
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = {
      only_path:   false,
      host:        ENV['RAILS_HOST'],
      port:        ENV['RAILS_PORT'],
      script_name: File.join(ENV['RAILS_RELATIVE_URL_ROOT'].to_s, '/'),
    }
    config.action_mailer.smtp_settings = {
      address:        ENV['RAILS_SMTP_ADDRESS'],
      port:           ENV['RAILS_SMTP_PORT'],
      domain:         ENV['RAILS_SMPT_DOMAIN'],
      authentication: false,
    }

  end
end
