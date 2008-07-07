class Cart
  SESSION_KEY = "shopping_cart"
  
  def initialize(session)
    @session = session
    puts @session[SESSION_KEY].to_s
    puts "TT #{@session['test']}"
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
    puts "save #{@data.to_yaml}"
    @session[SESSION_KEY] = @data #.to_yaml
  end
  
  def inspect
    @data.inspect
  end
end