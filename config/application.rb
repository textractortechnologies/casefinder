require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'stanford-core-nlp'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Casefinder
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
    config.active_job.queue_adapter = :delayed_job
    config.case_finder_config = config_for(:case_finder_config)
    
    Abstractor::Engine.routes.default_url_options[:host] = Rails.configuration.case_finder_config[:host]

    StanfordCoreNLP.use :english
    StanfordCoreNLP.model_files = {}
    StanfordCoreNLP.jar_path = "#{Rails.root}/lib/stanford-core-nlp/"
    StanfordCoreNLP.model_path = "#{Rails.root}/lib/stanford-core-nlp/"
    StanfordCoreNLP.jvm_args = ['-Xms1024M', '-Xmx2048M']
    StanfordCoreNLP.default_jars = [
      "joda-time.jar",
      "xom.jar",
      "stanford-corenlp-3.5.2.jar",
      "stanford-corenlp-3.5.2-models.jar",
      "jollyday.jar",
      "bridge.jar"
    ]

    config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix         => "[CaseFinder] #{Rails.env.titleize}",
      :sender_address       => Rails.configuration.case_finder_config[:sender_address],
      :exception_recipients => Rails.configuration.case_finder_config[:exception_recipients],
      :verbose_subject      => false
    }

    config.action_mailer.delivery_method        = :smtp
    config.action_mailer.smtp_settings          = Rails.configuration.case_finder_config[:smtp_settings]
    config.action_mailer.perform_deliveries     = true
    config.action_mailer.raise_delivery_errors  = true
  end
end
