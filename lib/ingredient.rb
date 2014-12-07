# encoding: utf-8
require 'date'
require_relative 'unit'

module UnitUtils
  def qty
    puts @unit.qty
  end
  
  def getUnit
    return @unit
  end
  
  def unit
    return @unit.unit_name
  end
end

#simplified ingredient class
class Ingredient
  attr_reader :name, :health
  
  attr_accessor :notes
  
  def initialize(name, health=nil)
    @name, @health = name, health
  end
  
  def addNotes (str)
    @notes += "\n#{str}"
  end
end

#ingredient as it appears in a recipe
class RecipeIngredient < Ingredient
  include UnitUtils
  def initialize(args)
    if args[:health]
      super(args[:name], args[:health])
    else
      super(args[:name])
    end
    unit = args[:unit].to_sym
    @unit = UnitFactory.build(args[:qty], unit)
  end
end

#ingredient as it appears in the pantry
class PantryIngredient < Ingredient
  include UnitUtils
  attr_accessor :qty, :cost
  attr_reader :expiration
  
  def initialize(args)
    if args[:health] then super(args[:name], args[:health])
    else super(args[:name]) end
      
    if args[:expiration] then @expiration = Date.parse(args[:expiration])
    else @expiration = nil end
    
    unit = args[:unit].to_sym
    @unit = UnitFactory.build(args[:qty], unit)

  end
  
  def is_expired?(date = Date.today)
    return @expiration > date
  end
end

pi = PantryIngredient.new({name: "beef", health: 7,
  expiration: "12/10/2014", qty:10, unit: "oz"})

puts Date.today
puts pi.qty