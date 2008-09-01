class BillingController < RailsVendorController
  
  def new
    @billing = RailsVendor::Billing.new
  end
  
  def create
    begin
      raise RailsVendor::Exception.new("Invalid card") unless @cart && @cart.total_price_cents && @cart.total_price_cents > 0
      #use a transaction so billing is only saved upon success
      RailsVendor::Billing.transaction do
        @billing = RailsVendor::Billing.new(params[:billing])
        @billing.save!
        active_merchant_credit_card = @billing.active_merchant_credit_card
        login = ENV['TRUST_COMMERCE_LOGIN'].to_s
        password = ENV['TRUST_COMMERCE_PASSWORD'].to_s
        gateway=ActiveMerchant::Billing::TrustCommerceGateway.new(:login => login,:password => password)
        cents = @cart.total_price_cents
        response = gateway.authorize(cents, active_merchant_credit_card)
        raise RailsVendor::Exception.new(response.message) unless response.success?
        authorization = response.authorization
        response2 = gateway.capture(cents, authorization, {})
        raise RailsVendor::Exception.new(response2.message) unless response2.success?
      end
      redirect_to :controller => "rails_vendor", :action => "purchase_success"
    rescue  ActiveRecord::RecordInvalid => exc
      render :action => "new"
    rescue RailsVendor::Exception => exc
      flash.now[:note] = exc.to_s
      render :action => "new"
    end
  end
end
