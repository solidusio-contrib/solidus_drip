# frozen_string_literal: true

namespace :drip do
  desc 'Imports order data into Drip'
  task import_orders: :environment do
    puts 'Starting Drip Order Import...'

    require 'drip'

    drip_client = SolidusDrip::Base.new.client

    # Completed Orders
    order_activities = []
    Spree::Order.complete.find_each do |order|
      drip = SolidusDrip::ShopperActivity::Order.new(order)
      action = drip_status(order)
      order_activities << drip.send(:order_data, action) # order_data is a private method

      # 1000 is the limit on orders that can be sent at a time. Once we have
      # that amount of data we send it all to Drip
      if order_activities.count == 1000
        puts 'Sending 1000 orders to Drip...'
        # Send to drip
        drip_client.create_order_activity_events(order_activities)
        # Reset
        order_activities = []
      end
    end

    # Send any extra data that wasn't part of the loop
    if order_activities.count.positive?
      puts "Sending remaining #{order_activities.count} orders to Drip..."
      drip_client.create_order_activity_events(order_activities)
    end

    # Incomplete Orders
    # Filtering out orders that do not have user information
    Spree::Order.incomplete.where('user_id IS NOT NULL OR email IS NOT NULL').find_each do |order|
      order.drip.cart_activity('created')
    end

    puts 'Drip Order Import Complete!'
  end
end

##
# Calculates the drip status to be sent for the given order
#
def drip_status(order)
  if order.shipped?
    'fulfilled'
  elsif order.paid?
    'paid'
  else
    'updated'
  end
end
