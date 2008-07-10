class Purchasable::Base
  SUBCLASS_NAMES = %w[Purchasable::FatRail Purchasable::HandRail]
  
  attr_reader :human_name
  attr_reader :short_description
  attr_reader :long_description
  attr_reader :unit_price
  attr_accessor :quantity
  
  @@subclasses = @@class_map = nil
  class << self
    def subclasses
      #return @@subclasses if @@subclasses
      #return @@subclasses = SUBCLASS_NAMES.collect{|n| exec(n)}
      [Purchasable::FatRail,Purchasable::HandRail,Purchasable::TrolleyRail]
    end
    
    def instances
      subclasses.collect{|s| s.new}
    end
    
    def find(id)
      return nil unless class_map[id]
      return class_map[id].new
    end
    
    def class_map
      return @@class_map if @@class_map
      @@class_map = {}
      instances.each{ |instance| @@class_map[instance.id] = instance.class}
      @@class_map
    end
  end
  
  def id
    self.human_name.gsub(' ','').underscore
  end
  
  def total_price
    raise "no quantity" unless quantity
    unit_price * quantity
  end
  
  def to_s
    self.human_name
  end
end
