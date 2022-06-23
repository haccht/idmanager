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
    config.time_zone = 'Tokyo'
    #config.active_job.queue_adapter = :sucker_punch

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = {
      host: '10.50.104.229',
      port: 3000,
      only_path: false,
      script_name: File.join(ENV['RAILS_RELATIVE_URL_ROOT'].to_s, '/'),
    }
    config.action_mailer.smtp_settings = {
      address:              'guard1.ssc-otemachi.ocn.ad.jp',
      port:                 25,
      authentication:       false,
      domain:               'magi.ssc-otemachi.ocn.ad.jp',
    }

  end
end
