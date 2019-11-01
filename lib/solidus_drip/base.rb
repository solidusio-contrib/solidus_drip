# frozen_string_literal: true

module SolidusDrip
  class Base
    include Spree::Core::Engine.routes.url_helpers

    attr_accessor :client

    def initialize(*_args)
      # TODO: Support Rails credentials
      drip_api_key = ENV['DRIP_API_KEY']
      drip_account_id = ENV['DRIP_ACCOUNT_ID']
      @client = ::Drip::Client.new do |c|
        c.api_key = drip_api_key
        c.account_id = drip_account_id
      end
    end

    private

    ##
    # When a response is not successful this method should be called
    # to handle it appropriately. Currently it logs the bad request and does
    # not stop the execution flow. A failed response from Drip shouldn't affect
    # the user experience with the site.
    #
    def handle_error_response(response)
      # Some errors come back under the `message` key while others are nested
      # under `error`
      error_message = response.body.dig('message') || response.body.dig('error', 'message')
      Rails.logger.error("SOLIDUS DRIP | #{error_message}")
    end
  end
end
