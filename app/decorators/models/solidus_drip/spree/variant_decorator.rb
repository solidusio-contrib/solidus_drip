# frozen_string_literal: true

module SolidusDrip
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.after_create(proc { |variant|
          variant.drip.product_activity('created')
        })
        base.after_update(proc { |variant|
          variant.drip.product_activity('updated') unless discarded?
        })
        base.after_discard(proc { |variant|
          variant.drip.product_activity('deleted')
        })
        base.after_destroy(proc { |variant|
          variant.drip.product_activity('deleted')
        })
      end

      def drip
        @drip ||= SolidusDrip::ShopperActivity::Product.new(self)
      end

      ::Spree::Variant.prepend self
    end
  end
end
