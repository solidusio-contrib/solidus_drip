# frozen_string_literal: true

module SolidusDrip
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.after_create :create_cart_activity
      end

      ##
      # Creates cart activity on Drip
      #
      # @see SolidusDrip::ShopperActivity
      #
      def create_cart_activity
        SolidusDrip::ShopperActivity.new(self).cart('created')
      end

      ##
      # Updates cart activity on Drip
      #
      # This method is called as part of the Spree::Order.update_hooks
      #
      # @see SolidusDrip::ShopperActivity
      #
      def update_cart_activity
        SolidusDrip::ShopperActivity.new(self).cart('updated')
      end

      ::Spree::Order.prepend self
    end
  end
end
