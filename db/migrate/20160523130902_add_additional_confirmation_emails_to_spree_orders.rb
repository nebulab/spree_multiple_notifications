class AddAdditionalConfirmationEmailsToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :additional_confirmation_emails, :text
  end
end
