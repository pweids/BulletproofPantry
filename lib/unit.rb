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
    @@volumeSet = Set.new ["gal", "qt", "pt", "c", "fl oz", "tbsp", "tsp"]
                
    @@weightSet = Set.new ["g", "lb", "oz"]
                 
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
  attr_reader :name, :conversions
  
  def initialize(name)
    @name = name
    #@conversions = {})
  end
end

class VolumeUnit < Unit
  
end

class WeightUnit < Unit
  
end


myUnit = UnitFactory.newUnit(10, "oz")
puts myUnit.class