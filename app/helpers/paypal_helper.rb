module PaypalHelper
  def paypal_submit
    "<input type=\"image\" src=\"/images/paypal_buy_now.gif\" name=\"submit\" alt=\"Pay with PayPal\">"
  end
  
  def notify_url
    url_for(:only_path => false, :controller => 'paypal', :action => 'notify') 
  end
end
