class PaypalController < ApplicationController
  include ActiveMerchant::Billing::Integrations
  ACCOUNT = "purposemc@gmail.com"
  #ACCOUNT = "ckh@spongecell.com"
  FORM_URL = "https://www.paypal.com/us/cgi-bin/webscr"
  
#  ACCOUNT = "ckh+se_1215756346_biz@spongecell.com" #sandbox
#  FORM_URL = "https://www.sandbox.paypal.com/cgi-bin/webscr" #sandbox
  #test buyer: ckh+bu_1215756310_per@spongecell.com
  
  skip_before_filter :verify_authenticity_token
  
  def notify
    notification = Paypal::Notification.new(request.raw_post)
    acknowledge = notification.acknowledge
    complete = notification.complete?
    logger.warn "Notify acknowledge: #{acknowledge} complete: #{complete}"
    render :text => "Success!"
  end
end
