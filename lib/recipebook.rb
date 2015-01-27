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
    ret = @recipes.select{|r| r.title.include? name}
    if ret.length == 1
      ret[0]
    else ret
    end
  end

  def getAllRecipes
    @recipes
  end

  def whatCanIMake?(pantry)
    @recipes.select {|recipe| pantry.can_I_make?(recipe)}
  end
end