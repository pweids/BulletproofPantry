# encoding: utf-8
require 'date'

module UnitUtils
  def qty
    return @unit.qty
  end
  
  def getUnit
    return @unit
  end
  
  def unit
    return @unit.unit_name
  end

  def unit_convert_to(unit_name)
    @unit.convert_to(unit_name.to_sym)
  end

  def unit_convert_to!(unit_name)
    @unit.convert_to!(unit_name.to_sym)
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
    notes += "\n#{str}"
  end

  def ==(other)
    if other.kind_of? String
      on = other.downcase
    elsif other.kind_of? Ingredient
      on = other.name.downcase
    else return false; end
    tn = name.downcase
    return on.include?(tn) || tn.include?(on)
  end

  def <=>(other)
    return name.downcase <=> other.name.downcase
  end
end

#ingredient as it appears in a recipe. Just has a qty
class RecipeIngredient < Ingredient
  attr_reader :unit
  include UnitUtils
  def initialize(args)
    if args[:health]
      super(args[:name], args[:health])
    else
      super(args[:name])
    end
    @unit = args[:unit]
  end
end

#ingredient as it appears in the pantry
class PantryIngredient < Ingredient
  include UnitUtils
  attr_reader :expiration, :unit, :cost
  
  def initialize(args)
    if args[:health] then super(args[:name], args[:health])
    else super(args[:name]) end
    @expiration = args[:expiration]
    @unit = args[:unit]

  end
  
  def is_expired?(date = Date.today)
    return expiration > date
  end

  def to_s
    return "#{name}: #{unit.qty} #{unit.unit_name}"
  end
end