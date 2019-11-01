# frozen_string_literal: true

module SolidusDrip
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.after_create(proc { |variant|
          variant.drip_shopper_activity.product_activity('created')
        })
        base.after_update(proc { |variant|
          variant.drip_shopper_activity.product_activity('updated')
        })
        base.after_destroy(proc { |variant|
          variant.drip_shopper_activity.product_activity('deleted')
        })
      end

      def drip_shopper_activity
        @drip_shopper_activity ||= SolidusDrip::ShopperActivity::Product.new(self)
      end

      ::Spree::Variant.prepend self
    end
  end
end
