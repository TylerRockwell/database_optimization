require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DatabaseOptimizations
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths << Rails.root.join("app", "jobs")
    config.active_job.queue_adapter = :delayed_job

    # Mailer configuration
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_options = {from: 'friendly.database@email.com'} #Can also set default from email here
    #Find these settings in Domain Information
    config.action_mailer.smtp_settings = {
      address:              'smtp.mailgun.org',
      port:                 587,
      domain:               'example.com',
      user_name:            ENV["MAILGUN_USERNAME"],
      password:             ENV["MAILGUN_PASSWORD"],
      authentication:       'plain',
      enable_starttls_auto: true  }

      config.paperclip_defaults = {
      storage: :s3,
      url: 's3_domain_url',
      path: '/:class/:attachment/:id_partition/:style/:filename',
      s3_credentials: {
        bucket: ENV['S3_BUCKET_NAME'],
        access_key: ENV['AWS_ACCESS_KEY'],
        secret_access_key: ENV['AWS_SECRET_KEY']
      }
  }
  end
end
