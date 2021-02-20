# frozen_string_literal: true

Spree::Order.register_update_hook(:update_drip_activity) unless SolidusDrip.use_events?
