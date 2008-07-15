class RailsVendorController < ApplicationController
  CONTACT_EMAIL_ADDRESS = "railsvendor@gmail.com"
  
  before_filter :init_cart
  
  def index
    @purchasables = Purchasable::Base.instances
  end
  
  def detail
    @purchasable = Purchasable::Base.find(params[:id])
  end
  
  def add_to_cart
    @purchased = Purchasable::Base.find(params[:purchasable][:id])
    @purchased.quantity = params[:purchasable][:quantity].to_i
    @cart.add(@purchased)
    @cart.save
    render :action => "cart"
  end
  
  def checkout
  end
  
  def empty_cart
    @cart.clear
    redirect_to "/"
  end
  
  def purchase_success
    @cart.clear
  end
  
  protected
  def init_cart
    #ActiveMerchant::Billing::Base.integration_mode = :test #sandbox
    @cart = RailsVendor::Cart.new(session)
  end
end
