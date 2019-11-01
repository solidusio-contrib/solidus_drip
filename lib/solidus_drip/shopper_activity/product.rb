# frozen_string_literal: true

module SolidusDrip
  module ShopperActivity
    class Product < SolidusDrip::Base
      attr_accessor :variant

      ##
      # ShopperActivity::Product relies on Spree::Variant data to be useful.
      # We call super to initialize the client and then we set the variant
      # attribute to be used in the API calls.
      #
      # @param variant [Spree::Variant] the variant to be recorded
      #
      def initialize(variant)
        super
        @variant = variant
      end

      ##
      # Product Activity helps identify variant updates.
      #
      # @param action [String] the product action, `created`, `updated`, or `deleted`
      # @see https://developer.drip.com/#product-activity
      #
      def product_activity(action)
        data = {
          provider: 'solidus',
          action: action,
          product_id: variant.product_id,
          product_variant_id: variant.id,
          sku: variant.sku,
          name: variant.name,
          categories: variant.product.taxons.pluck(:name),
          price: variant.price,
          inventory: variant.total_on_hand,
          product_url: product_url(variant.product)
        }

        response = client.create_product_activity_event(data)
        handle_error_response(response) if !response.success?

        response
      end
    end
  end
end
