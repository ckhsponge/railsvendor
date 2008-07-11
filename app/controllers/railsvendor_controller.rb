class RailsvendorController < ApplicationController
  
  before_filter :init_cart
  
  def index
    @purchasables = Purchasable::Base.instances
  end
  
  def detail
    @purchasable = Purchasable::Base.find(params[:id])
  end
  
  def purchase
    @cart.add(params[:purchasable][:id],params[:purchasable][:quantity].to_i)
    @cart.save
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
    @cart = Cart.new(session)
  end
end
