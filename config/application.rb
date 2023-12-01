require_relative "boot"

require 'csv'
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SoarBase
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
    config.action_mailer.default_url_options = { host: "eaglevillesoaring.com" }

    config.assets.initialize_on_precompile = false

    # Use sidekiq for active jobs
    config.active_job.queue_adapter = :sidekiq

    def index
      flash.danger = 'No page found at that address'
      redirect_to root_path
    end

  end
end
