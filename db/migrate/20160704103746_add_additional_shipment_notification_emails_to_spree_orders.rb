class AddAdditionalShipmentNotificationEmailsToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :additional_shipment_notification_emails, :text
  end
end
