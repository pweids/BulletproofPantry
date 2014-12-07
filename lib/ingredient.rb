# package of ingredient classes
require 'date'

#simplified ingredient class
class Ingredient
  attr_reader :name, :health
  
  def initialize(name, health)
    @name, @health = name, health
  end
  
  def self.convert_to(unit)
    #TODO: convert the current qty to this unit
  end
  
end

#ingredient as it appears in a recipe
class RecipeIngredient < Ingredient
  attr_reader :qty
  
  def initialize(args)
    super(args[:name], args[:health])
    unit = args[:unit].to_sym if not args[:unit].is_a? Symbol
  end
end

#ingredient as it appears in the pantry
class PantryIngredient < Ingredient
  attr_accessor :qty, :cost
  attr_reader :expiration
  
  def initialize(args)
    super(args[:name], args[:health])
    unit = args[:unit].to_sym if not args[:unit].is_a? Symbol
    @expiration = Date.parse(args[:expiration])
  end
  
  def is_expired?(date = Date.today)
    return @expiration > date
  end
end

pi = PantryIngredient.new({name: "beef", health: 7,
  expiration: "12/10/2014", qty:10, unit: "oz"})

puts Date.today
puts pi.is_expired?