# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

module SolidusDrip
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_drip'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'solidus_drip.pub_sub' do |app|
      unless SolidusSupport::LegacyEventCompat.using_legacy?
        app.reloader.to_prepare do
          SolidusDrip::OrderUpdaterSubscriber.omnes_subscriber.subscribe_to(::Spree::Bus)
        end
      end
    end
  end
end
