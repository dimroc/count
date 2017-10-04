require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CountingCompany
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.assets false
      g.helper false
      g.stylesheets false
      g.javascripts false
      g.decorator false
    end

    config.eager_load_paths << "#{Rails.root}/lib"
    config.eager_load = true

    config.imgix = {
      source: "countingcompany.imgix.net",
      secure_url_token: "fPWGRJ37krZDYdMj",
      hostname_to_replace: 'storage.googleapis.com'
    }
  end
end
