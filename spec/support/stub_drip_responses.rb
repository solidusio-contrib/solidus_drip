# frozen_string_literal: true

# Stub requests to Drip API
RSpec.configure do |config|
  config.before(:each) do
    response = Drip::Response.new(200, {
      "request_id": "990c99a7-5cba-42e8-8f36-aec3419186ef"
    })
    allow_any_instance_of(Drip::Client).to receive(:create_cart_activity_event).and_return(response)
    allow_any_instance_of(Drip::Client).to receive(:create_order_activity_event).and_return(response)
    allow_any_instance_of(Drip::Client).to receive(:create_product_activity_event).and_return(response)
  end
end
