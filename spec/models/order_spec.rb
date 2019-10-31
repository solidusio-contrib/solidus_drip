# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Order do
  let!(:order) { create(:order) }

  describe '#create_cart_activity' do
    it "triggers on create" do
      expect_any_instance_of(SolidusDrip::ShopperActivity).to(
        receive(:cart_activity).with('created'))
      create(:order)
    end
  end

  describe '#update_drip_activity' do
    it "triggers as an update_hook" do
      expect_any_instance_of(SolidusDrip::ShopperActivity).to(
        receive(:cart_activity).with('updated'))
      order.recalculate
    end
  end
end
