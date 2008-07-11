module PaypalHelper
  def paypal_submit
    "<input type=\"image\" src=\"http://www.paypal.com/en_US/i/btn/x-click-but01.gif\" name=\"submit\" alt=\"Pay with PayPal\">"
  end
  
  def notify_url
    url_for(:only_path => false, :controller => 'paypal', :action => 'notify') 
  end
end
