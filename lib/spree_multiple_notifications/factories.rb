FactoryGirl.modify do
  factory :shipped_order do
    additional_confirmation_emails 3.times.map { Faker::Internet.email }.join(",")
    additional_shipment_notification_emails 3.times.map { Faker::Internet.email }.join(",")
  end
end
