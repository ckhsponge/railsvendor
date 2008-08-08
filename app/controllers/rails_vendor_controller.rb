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
  
  #fill the card with some random items and go to the checkout screen
  def example_code
    for purchasable in RailsVendor::Purchasable.find(:all)
      purchasable.quantity = rand 5
      @cart.add(purchasable)
    end
    if @cart.empty?
      purchasable = RailsVendor::Purchasable.find(:all).first
      purchasable.quantity = (rand 5)+1
      @cart.add(purchasable)
    end
    @cart.save
    redirect_to :action => "checkout"
  end
  
  def checkout
    @convertor = Syntax::Convertors::HTML.for_syntax "ruby"
  end
  
  def empty_cart
    @cart.clear
    redirect_to "/"
  end
  
  def purchase_success
    @purchased = @cart.to_a
    @cart.clear
  end
  
  protected
  def init_cart
    #ActiveMerchant::Billing::Base.integration_mode = :test #sandbox
    @cart = RailsVendor::Cart.new(session)
  end
end
