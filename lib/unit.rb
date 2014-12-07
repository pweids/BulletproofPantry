# make the unit class
=begin
Volume symbols:
gal, gallon, gallons
qt, quart, quarts
pt, pint, pints
c, cup, cups
fl. oz., fl oz, fluid ounce, fluid ounces
tbsp, tablespoon, tablespoons
tsp, teaspoon, teaspoons

Weight symbols:
g, gram, grams
lb, lbs, pound, pounds
oz, ounce, ounces
=end

require 'set'

class UnitFactory
    @@volumeSet = Set.new ["gal", "gallon", "gallons",
                 "qt", "quart", "quarts",
                 "pt", "pint", "pints",
                 "c", "cup", "cups",
                 "fl.  oz.", "fl oz", "fluid ounce", "fluid ounces",
                 "tbsp", "tablespoon", "tablespoons",
                 "tsp", "teaspoon", "teaspoons"]
                
    @@weightSet = Set.new ["g", "gram", "grams",
                 "lb", "lbs", "pound", "pounds",
                 "oz", "ounce", "ounces"]
                 
  def self.newUnit(qty, name)
    name = name.to_s
    if @@volumeSet.include?(name)
      return VolumeUnit.new(name)
    elsif @@weightSet.include?(name)
      return WeightUnit.new(name)
    else 
      raise ArgumentError
    end
  end
end

class Unit
  attr_reader :name, :aliases, :conversions
  
  @@definitions = {}
  
  def initialize(name)
    @name = name
    #@aliases = Set.new
    #@conversions = {}
    #add_alias(name)
  end
  
  def add_alias(*args)
    #args.each do |unit_alias|
     # @aliases << unit_alias.to_s
      #@definitions[unit_alias.to_s.downcase] = self
    #end
  end
  
end

class VolumeUnit < Unit
  
end

class WeightUnit < Unit
  
end


myUnit = UnitFactory.newUnit(10, "oz")
puts myUnit.class