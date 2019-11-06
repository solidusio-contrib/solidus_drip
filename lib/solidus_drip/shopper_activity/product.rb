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
        response = client.create_product_activity_event(product_data(action))
        handle_error_response(response) if !response.success?

        response.success?
      end

      private

      ##
      # Formats data to be used in Drip product calls
      #
      def product_data(action)
        {
          provider: 'solidus',
          action: action,
          product_id: variant.product_id.to_s,
          product_variant_id: variant.id.to_s,
          sku: variant.sku,
          name: variant.name,
          categories: variant.product.taxons.pluck(:name),
          price: variant.price.to_f,
          inventory: variant.total_on_hand,
          product_url: product_url(variant.product)
        }
      end
    end
  end
end
