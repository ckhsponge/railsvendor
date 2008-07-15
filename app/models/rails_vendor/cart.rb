class RailsVendor::Cart
  SESSION_KEY = "shopping_cart"
  
  def initialize(session)
    @session = session
    @session['test'] = 'howdy'
    @data = {}
    if @session[SESSION_KEY] && @session[SESSION_KEY].keys #YAML.load(@session[SESSION_KEY]).keys
      for key in @session[SESSION_KEY].keys
        @data[key] = @session[SESSION_KEY][key].to_i
      end
    end
  end
  
  def add(purchasable)
    @data[purchasable.id] ||= 0
    @data[purchasable.id] += purchasable.quantity
  end
  
  def clear
    @session[SESSION_KEY] = @data = {}
  end
  
  def save
    @session[SESSION_KEY] = @data #.to_yaml
  end
  
  def total_count
    @data.keys.inject(0) {|sum,key| sum + @data[key]}
  end
  
  def total_price
    self.to_a.inject(0) {|sum,p| sum + p.total_price}
  end
  
  def empty?
    @data.size == 0
  end
  
  def inspect
    @data.inspect
  end
  
  def to_a
    result = []
    for key in @data.keys
      purchasable = Purchasable::Base.find(key)
      purchasable.quantity = @data[key]
      result << purchasable
    end
    result
  end
end
