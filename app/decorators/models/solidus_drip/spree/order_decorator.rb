# frozen_string_literal: true

module SolidusDrip
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.after_create(proc { |order|
          order.drip.cart_activity('created')
        })
        base.state_machine.after_transition(to: :complete, do: proc { |order|
          order.finialize_drip_activity unless SolidusDrip.use_events?
        })
        base.state_machine.after_transition(to: :canceled, do: proc { |order|
          order.drip.order_activity('canceled')
        })
      end

      ##
      # Updates activity on Drip
      #
      # This method is called by 'order_recalculated' event emitted in Solidus
      #
      # @see SolidusDrip::ShopperActivity::Order
      #
      def update_drip_activity
        return if canceled?

        # If the order is complete it is no longer considered cart data
        if completed?
          if shipment_state_changed? && shipped?
            drip.order_activity('fulfilled')
          end
          if payment_state_changed? && paid?
            drip.order_activity('paid')
          end
          drip.order_activity('updated')
        else
          drip.cart_activity('updated')
        end
      end

      ##
      # Updates activity on Drip
      #
      # This method is called by 'order_finalized' event emitted in Solidus
      #
      # @see SolidusDrip::ShopperActivity::Order
      #
      def finialize_drip_activity
        drip.order_activity('placed')
      end

      def drip
        @drip ||= SolidusDrip::ShopperActivity::Order.new(self)
      end

      ::Spree::Order.prepend self
    end
  end
end
