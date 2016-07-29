require 'spec_helper'

describe Spree::Order, :type => :model do
  let(:order) { create :order_with_line_items,
                        additional_confirmation_emails: nil,
                        additional_shipment_notification_emails: nil }

  context "when is just created and does not have emails" do
    it 'has no errors when going from cart to address state' do
      order.next
      expect(order.state).to eq('address')
    end
  end

  context "when doing next from address state" do
    before do
      order.next # go from cart to address
      order.additional_confirmation_emails = additional_confirmation_emails
      order.additional_shipment_notification_emails = additional_shipment_notification_emails
      order.next # go from address to delivery
    end

    context "when emails format is wrong" do
      let(:additional_confirmation_emails)          { "wrong email address" }
      let(:additional_shipment_notification_emails) { "wrong email address" }

      it "will have validation errors (is invalid)" do
        expect(order.errors[:additional_confirmation_emails].size).to          eq (1)
        expect(order.errors[:additional_confirmation_emails]).to               eq (["is invalid"])
        expect(order.errors[:additional_shipment_notification_emails].size).to eq (1)
        expect(order.errors[:additional_shipment_notification_emails]).to      eq (["is invalid"])
      end
    end

    context "when emails format is correct" do
      let(:additional_confirmation_emails)          { 3.times.map { Faker::Internet.email }.join(",") }
      let(:additional_shipment_notification_emails) { 3.times.map { Faker::Internet.email }.join(",") }

      it "will go to the next state" do
        expect(order.state).to eq ('delivery')
      end
    end

    ## MUTING TEST.WE ARE NOW ACCEPTING BLANK FIELDS
    # context "when emails are blank" do
    #   let(:additional_confirmation_emails)          { "" }
    #   let(:additional_shipment_notification_emails) { "" }
    #
    #   it "will have validation errors (can't be blank, is invalid)" do
    #     expect(order.errors[:additional_confirmation_emails].size).to          eq (2)
    #     expect(order.errors[:additional_confirmation_emails]).to               eq (["can't be blank", "is invalid"])
    #     expect(order.errors[:additional_shipment_notification_emails].size).to eq (2)
    #     expect(order.errors[:additional_shipment_notification_emails]).to      eq (["can't be blank", "is invalid"])
    #   end
    # end
  end
end
