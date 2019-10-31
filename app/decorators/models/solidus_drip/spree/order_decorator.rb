# frozen_string_literal: true

module SolidusDrip
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.after_create(proc { |order|
          order.drip_shopper_activity.cart_activity('created')
        })
        base.state_machine.after_transition(to: :complete, do: proc { |order|
          order.drip_shopper_activity.order_activity('placed')
        })
        base.state_machine.after_transition(to: :canceled, do: proc { |order|
          order.drip_shopper_activity.order_activity('canceled')
        })
      end

      ##
      # Updates activity on Drip
      #
      # This method is called as part of the Spree::Order.update_hooks
      #
      # @see SolidusDrip::ShopperActivity
      #
      def update_drip_activity
        # If the order is complete it is no longer considered cart data
        if completed?
          if shipment_state_changed? && shipped?
            drip_shopper_activity.order_activity('fulfilled')
          end
          if payment_state_changed? && paid?
            drip_shopper_activity.order_activity('paid')
          end
          drip_shopper_activity.order_activity('updated')
        else
          drip_shopper_activity.cart_activity('updated')
        end
      end

      def drip_shopper_activity
        @drip_shopper_activity ||= SolidusDrip::ShopperActivity.new(self)
      end

      ::Spree::Order.prepend self
    end
  end
end
