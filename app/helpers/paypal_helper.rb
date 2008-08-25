module PaypalHelper
  def website_standard_active_merchant(&proc)
    s = payment_service_for 1000, PaypalController::ACCOUNT,
    :currency => 'USD', 
    :service => :paypal, 
    :html => { :id => 'payment-form' } do |service| 
      service.cmd "_cart"
      service.add_field 'upload', "1"
      service.no_shipping '1' 
      #the helper sets up an item by default. we shall delete that info
      service.form_fields.delete('item_name')
      service.form_fields.delete('item_number')
      service.form_fields.delete('quantity')
      #upload the entire cart
      i = 1
      for purchasable in @cart.to_a
        service.add_field "item_name_#{i}",purchasable.human_name
        service.add_field "amount_#{i}",fmt_money(purchasable.unit_price)
        service.add_field "quantity_#{i}",purchasable.quantity
        i += 1
      end
      service.notify_url notify_url
      service.return_url url_for(:action=>"purchase_success",:only_path=>false)
      service.cancel_return_url url_for(:action=>"checkout",:only_path=>false)
      paypal_submit
    end
    yield
    puts s
    s
    concat(s, proc.binding)
  end
  
  def paypal_submit
    "<input type=\"image\" src=\"/images/paypal_buy_now.gif\" name=\"submit\" alt=\"Pay with PayPal\">"
  end
  
  def notify_url
    url_for(:only_path => false, :controller => 'paypal', :action => 'notify') 
  end
end
