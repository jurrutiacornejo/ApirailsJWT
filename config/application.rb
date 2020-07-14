require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Apirails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.generators do |g|
      g.template_engine nil #para saltar las vistas
      g.test_framework nil #para saltar el framework de test
      g.assets false
      g.stylesheets false
    end
    config.i18n.load_path += Dir[Rails.root.join('my','locales', '*{rb,yml}').to_s]
    config.i18n.default_locale = :es
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
