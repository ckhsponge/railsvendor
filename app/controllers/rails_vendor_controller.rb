class RailsVendorController < ApplicationController
  require 'syntax/convertors/html'

  CONTACT_EMAIL_ADDRESS = "railsvendor@gmail.com"
  
  before_filter :init_cart
  
  def index
    @purchasables = RailsVendor::Purchasable.find(:all)
  end
  
  def syntax
    convertor = Syntax::Convertors::HTML.for_syntax "ruby"
    #html = convertor.convert( "class Banana\ndef doit\ns = 'this is a strin'\nend\nend") #File.read( "program.rb" ) )
    @code = convertor.convert( File.read( "app/controllers/billing_controller.rb" ), true )
    
    #html = "<div style='font-size:140%' class='ruby'>\n#{html}</div>"
    #render :text => html, :layout => "rails_vendor"
  end
  
  def detail
    @purchasable = RailsVendor::Purchasable.find(params[:id])
  end
  
  def add_to_cart
    @purchased = RailsVendor::Purchasable.find(params[:purchasable][:id])
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
