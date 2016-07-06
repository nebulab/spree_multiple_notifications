module OrderRecipients
  def mail(headers={}, &block)
    headers[:to] = @order.order_confirmation_emails
    super
  end
end

Spree::OrderMailer.class_eval do
  prepend OrderRecipients
end
