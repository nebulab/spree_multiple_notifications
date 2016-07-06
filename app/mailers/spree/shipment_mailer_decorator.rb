module ShipmentRecipients
  def mail(headers={}, &block)
    headers[:to] = @shipment.order.shipment_notification_emails
    super
  end
end

Spree::ShipmentMailer.class_eval do
  prepend ShipmentRecipients
end
