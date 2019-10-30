# frozen_string_literal: true

module SolidusDrip
  class ShopperActivity < SolidusDrip::Base
    include Spree::Core::Engine.routes.url_helpers

    attr_accessor :order

    def initialize(order)
      super
      @order = order
    end

    ##
    # Cart Activity helps identify cart abandonment.
    # @see https://developer.drip.com/#cart-activity
    #
    def cart(action = 'updated')
      data = {
        provider: 'solidus',
        email: order.email,
        action: action,
        cart_id: order.id.to_s,
        cart_public_id: order.number,
        grand_total: order.total.to_f,
        total_discounts: order.promo_total.to_f,
        currency: order.currency,
        cart_url: cart_url,
        items: order.line_items.map do |line_item|
          {
            product_id: line_item.product.id.to_s,
            product_variant_id: line_item.variant_id.to_s,
            sku: line_item.sku,
            name: line_item.name,
            categories: line_item.product.taxons.pluck(:name),
            price: line_item.price.to_f,
            quantity: line_item.quantity,
            discounts: line_item.promo_total.to_f,
            total: line_item.total.to_f,
            product_url: product_url(line_item.product)
          }
        end
      }

      response = client.create_cart_activity_event(data)
      if !response.success?
        Rails.logger.error("SOLIDUS DRIP | #{response.body.dig('error', 'message')}")
      end

      response
    end
  end
end
