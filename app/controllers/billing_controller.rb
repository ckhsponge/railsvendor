class BillingController < RailsVendorController
  
  def new
    @billing = RailsVendor::Billing.new
  end
  
  def create
    RailsVendor::Billing.transaction do
      billing = RailsVendor::Billing.create(params[:billing])
      active_merchant_credit_card = billing.active_merchant_credit_card
      login = ""
      password = ""
      gateway=ActiveMerchant::Billing::TrustCommerceGateway.new(
        :login=>login,:password=>password)
      cents = 100
      r1 = gateway.authorize(cents, active_merchant_credit_card)
      puts "r1 #{r1.inspect}"
      authorization = r1.authorization
      r2 = gateway.capture(cents, authorization, {})
      puts "r2 #{r2.inspect}"
    end
  end
end
