class Purchasable::Base
  SUBCLASS_NAMES = %w[Purchasable::FatRail Purchasable::HandRail]
  
  attr_reader :human_name
  attr_reader :short_description
  attr_reader :long_description
  attr_reader :quantity
  
  @@subclasses = nil
  class << self
    def subclasses
      #return @@subclasses if @@subclasses
      #return @@subclasses = SUBCLASS_NAMES.collect{|n| exec(n)}
      [Purchasable::FatRail,Purchasable::HandRail]
    end
    
    def instances
      subclasses.collect{|s| s.new}
    end
    
    def find(id)
      instances.delete_if{|i| i.id != id}.first
    end
  end
  
#  def human_name
#    @human_name
#  end
  
  def id
    self.human_name.gsub(' ','').underscore
  end
  
  def to_s
    self.human_name
  end
end
