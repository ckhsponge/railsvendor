class Purchasable::FatRail < Purchasable::Base
  
  def initialize
    super
    @human_name = "Fat Rail"
    @short_description = "Slightly wider than a normal rail"
    @long_description = "This rail bears the load of even the heaviest of trains."
    @unit_price = 0.75
  end
end
