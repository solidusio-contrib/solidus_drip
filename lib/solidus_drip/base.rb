# frozen_string_literal: true

module SolidusDrip
  class Base
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
      Rails.logger.error("SOLIDUS DRIP | #{response.body.dig('error', 'message')}")
    end
  end
end
