require_relative "recipe"
require_relative "ingredient"

class RecipeBook
  include Enumerable
  def initialize
    @recipes = Array.new
  end

  def each
    @recipes.each do
      yield
    end
  end

  def addRecipe(recipe)
    @recipes << recipe
  end

  def getRecipe(name)
  end

  def getAllRecipes
    @recipes
  end

  def whatCanIMake?(pantry)
    @recipes.select {|recipe| pantry.canIMake?(recipe)}
  end
end