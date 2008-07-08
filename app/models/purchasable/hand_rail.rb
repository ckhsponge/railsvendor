class Purchasable::HandRail < Purchasable::Base
  def initialize
    super
    @human_name = "Hand Rail"
    @short_description = "Helps with balance while navigating stairs"  
    @long_description = "Avoid accideents by installing this rail anywhere someone could trip and fall."
    @unit_price = 0.57
  end
end
