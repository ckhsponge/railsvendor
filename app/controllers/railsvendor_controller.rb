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
  
  def check_out
    @cart.clear
  end
  
  def init_cart
    @cart = Cart.new(session)
  end
end
