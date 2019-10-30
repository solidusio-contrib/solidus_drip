# frozen_string_literal: true

# A default_host is required to generate full URL paths to be sent to Drip
# Here we initialize one if one is not present

if Spree::Core::Engine.routes.default_url_options.dig(:host).blank?
  Rails.logger.warn('solidus_drip, default_url_options was blank and is being set to localhost')
  Spree::Core::Engine.routes.default_url_options[:host] = 'localhost:3000'
end
