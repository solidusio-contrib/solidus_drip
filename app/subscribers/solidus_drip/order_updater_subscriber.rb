module SolidusDrip
  module OrderUpdaterSubscriber
    include ::Spree::Event::Subscriber
    include ::SolidusSupport::LegacyEventCompat::Subscriber

    event_action :order_recalculated
    event_action :order_finalized

    def order_recalculated(event)
      order = event.payload[:order]
      order.update_drip_activity
    end

    def order_finalized(event)
      order = event.payload[:order]
      order.finialize_drip_activity
    end
  end
end
