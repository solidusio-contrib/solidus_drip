# frozen_string_literal: true

module SolidusDrip
  module Spree
    module OrderDecorator
      ##
      # Sends cart activity to Drip. `action` is calculated based on if the
      # object was just created or is being updated.
      #
      # This method is called as part of the Spree::Order.update_hooks
      #
      # @see SolidusDrip::ShopperActivity
      #
      def record_cart_activity
        action = created_at_changed? ? 'created' : 'updated'
        SolidusDrip::ShopperActivity.new(self).cart(action)
      end

      ::Spree::Order.prepend self
    end
  end
end
