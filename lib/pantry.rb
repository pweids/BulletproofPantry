class Pantry
  def initialize
    @stock = Array.new
  end

  def canIMake?(recipe)
  end

  def whatIsMissing?(recipe)
  end

  def whatIsExpired?
  end

  def addIngredient(ingredient)
    @stock << ingredient
  end

  def removeIngredient(ingredient)
  end

  def updateIngredient(ingredient)
  end

  def displayIngredients
  end

  def findIngredient(name)
    @stock.select{|item| item == ingredient}
  end
end