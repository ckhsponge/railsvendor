class Cart
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
  
  def add(purchasable_id,quantity)
    @data[purchasable_id] ||= 0
    @data[purchasable_id] += quantity
  end
  
  def clear
    @session[SESSION_KEY] = @data = {}
  end
  
  def save
    @session[SESSION_KEY] = @data #.to_yaml
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