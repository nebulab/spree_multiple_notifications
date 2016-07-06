require 'spec_helper'
require 'email_spec'

describe Spree::ShipmentMailer, :type => :mailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before { create(:store) }

  let(:shipment) do
    order = stub_model(Spree::Order)
    order.email = Faker::Internet.email
    product = stub_model(Spree::Product, :name => %Q{The "BEST" product})
    variant = stub_model(Spree::Variant, :product => product)
    line_item = stub_model(Spree::LineItem, :variant => variant, :order => order, :quantity => 1, :price => 5)
    shipment = stub_model(Spree::Shipment)
    allow(shipment).to receive_messages(:line_items => [line_item], :order => order)
    allow(shipment).to receive_messages(:tracking_url => "TRACK_ME")
    shipment
  end

  context "when order does have multiple recipients" do
    before do
      shipment.order.additional_shipment_notification_emails = 3.times.map { Faker::Internet.email }.join(",")
    end

    it "sends shipment email to all additional shipment notification emails" do

      message = Spree::ShipmentMailer.shipped_email(shipment)
      message.deliver_now
      expect(message.to).to eq(shipment.order.additional_shipment_notification_emails.split(","))
      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(ActionMailer::Base.deliveries.first.to).to eq(shipment.order.additional_shipment_notification_emails.split(","))
    end
  end
end
