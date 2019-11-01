# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Order do
  let(:order) { create(:order_ready_to_complete) }
  let(:drip) { order.drip }

  describe '#create_cart_activity' do
    it "triggers on create" do
      expect_any_instance_of(SolidusDrip::ShopperActivity::Order).
        to(receive(:cart_activity).with('created'))
      create(:order)
    end
  end

  describe '#update_drip_activity' do
    it "triggers as a cart update_hook if order is not completed" do
      expect(drip).to(receive(:cart_activity).with('updated'))
      order.recalculate
    end

    it "triggers placed event on complete" do
      expect(drip).to(receive(:order_activity).with('placed'))
      order.complete!
    end

    context "completed order" do
      let!(:order) { create(:completed_order_with_pending_payment) }

      it "triggers fulfilled event on shipments being shipped" do
        expect(drip).to(receive(:order_activity).with('updated'))
        expect(drip).to(receive(:order_activity).with('fulfilled'))
        order.shipments.update(state: 'ready')
        order.shipments.map(&:ship!)
      end

      it "triggers paid event on payments being captured" do
        expect(drip).to(receive(:order_activity).with('updated'))
        expect(drip).to(receive(:order_activity).with('paid'))
        order.payments.map(&:complete!)
      end
    end
  end
end
