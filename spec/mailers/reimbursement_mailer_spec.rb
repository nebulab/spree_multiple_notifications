require 'spec_helper'
require 'email_spec'

describe Spree::ReimbursementMailer, :type => :mailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:reimbursement) { create(:reimbursement) }

  before do
    reimbursement.order.email = Faker::Internet.email
  end

  context "when order does have multiple recipients" do
    before do
      reimbursement.order.additional_confirmation_emails = 3.times.map { Faker::Internet.email }.join(",")
    end

    it "sends reimbursement email to order email" do

      message = Spree::ReimbursementMailer.reimbursement_email(reimbursement)
      message.deliver_now
      expect(message.to).to eq([reimbursement.order.email])
      expect(ActionMailer::Base.deliveries.count).to eq 1
      expect(ActionMailer::Base.deliveries.first.to).to eq([reimbursement.order.email])
    end
  end
end
