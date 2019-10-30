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
  end
end
