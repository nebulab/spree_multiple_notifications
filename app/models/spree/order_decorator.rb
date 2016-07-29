module Spree
  Order.class_eval do
    [:additional_confirmation_emails, :additional_shipment_notification_emails].each do |column|
      validates column,
                allow_blank: true,
                if: :require_email,
                format: { with: /(\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})(,\s*([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,}))*\z)/i }
    end

    def order_confirmation_emails
      additional_confirmation_emails.split(/\s*,\s*/).join(",")
    end

    def shipment_notification_emails
      additional_shipment_notification_emails.split(/\s*,\s*/).join(",")
    end
  end
end
