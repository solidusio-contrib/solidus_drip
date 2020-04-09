# frozen_string_literal: true

namespace :drip do
  desc 'Imports product data into Drip'
  task import_products: :environment do
    puts 'Starting Drip Product Import...'

    require 'drip'

    Spree::Variant.all.find_each do |variant|
      variant.drip.product_activity('created')
    end

    puts 'Drip Product Import Complete!'
  end
end
