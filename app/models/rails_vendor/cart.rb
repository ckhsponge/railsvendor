#this cart simply stores a hash of purchasable ids to quantities
class RailsVendor::Cart
  SESSION_KEY = "shopping_cart"
  
  #creates a new cart or instantiates an existing cart
  def initialize(session)
    @session = session
    @data = {}
    if @session[SESSION_KEY] && @session[SESSION_KEY].keys
      for key in @session[SESSION_KEY].keys
        @data[key] = @session[SESSION_KEY][key].to_i
      end
    end
  end
  
  #adds the purchasable to this cart, does not yet write it to the session
  def add(purchasable)
    return unless purchasable.quantity && purchasable.quantity > 0
    @data[purchasable.id] ||= 0
    @data[purchasable.id] += purchasable.quantity
  end
  
  #empties cart
  def clear
    @session[SESSION_KEY] = @data = {}
  end
  
  #writes the data into the session
  def save
    @session[SESSION_KEY] = @data
  end
  
  #sum of all quantities
  def total_count
    @data.keys.inject(0) {|sum,key| sum + @data[key]}
  end
  
  #sum of all quantity*prices
  def total_price
    self.to_a.inject(0) {|sum,p| sum + p.total_price}
  end
  
  #returns an integer
  def total_price_cents
    (self.total_price*100).round.to_i
  end
  
  def empty?
    @data.size == 0
  end
  
  def inspect
    @data.inspect
  end
  
  #returns an array of purchasables
  def to_a
    result = []
    for key in @data.keys
      purchasable = RailsVendor::Purchasable.find(key)
      purchasable.quantity = @data[key]
      result << purchasable
    end
    result
  end
end
