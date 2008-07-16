#acts like ActiveRecord but data is laoded from hashes
class RailsVendor::Purchasable
  INSTANCES = [
  {:id => "1", :human_name => "Fat Rail", :short_description => "Slightly wider than a normal rail", 
    :long_description => "This rail bears the load of even the heaviest of trains.", :unit_price => 0.75},
  {:id => "2", :human_name => "Hand Rail", :short_description => "Helps with balance while navigating stairs", 
    :long_description => "Avoid accideents by installing this rail anywhere someone could trip and fall.", :unit_price => 0.57},
  {:id => "3", :human_name => "Trolley Rail", :short_description => "Serves light trains and street cars", 
    :long_description => "The old trollies of San Francisco were once pulled by mules underneath the street.", :unit_price => 0.93}
  ]
  INSTANCE_MAP = {}
  INSTANCES.each{ |instance| INSTANCE_MAP[instance[:id]] = instance}
  
  #read-only attributes
  attr_reader :id
  attr_reader :human_name
  attr_reader :short_description
  attr_reader :long_description
  attr_reader :unit_price
  #writable attributes
  attr_accessor :quantity
  
  class << self
    #finds by id or returns all
    def find(id)
      if :all == id
        return INSTANCES.collect{ |i| RailsVendor::Purchasable.new(i) }
      end
      RailsVendor::Purchasable.new( INSTANCE_MAP[id] )
    end
  end
  
  def initialize(args)
    @id = args[:id]
    @human_name = args[:human_name]
    @short_description = args[:short_description]
    @long_description = args[:long_description]
    @unit_price = args[:unit_price]
  end
  
  def total_price
    raise "no quantity" unless quantity
    unit_price * quantity
  end
  
  def to_s
    self.human_name
  end
  
end