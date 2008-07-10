class Purchasable::TrolleyRail < Purchasable::Base
  def initialize
    super
    @human_name = "Trolley Rail"
    @short_description = "Serves light trains and stret cars"  
    @long_description = "The old trollies of San Francisco were once pulled by mules underneath the street."
    @unit_price = 0.93
  end
end
