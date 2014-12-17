require_relative "recipebook"
require_relative "pantry"

class User
  attr_accessor :recipe_book, :pantry, :name
  def initialize(name)
    @pantry = Pantry.new
    @recipe_book = RecipeBook.new
    @name = name
  end

  def add_recipe(recipe)
    recipe_book.addRecipe(recipe)
  end

  def add_ingredient_to_pantry(ingredient)
    if !ingredient.nil?
      @pantry.addIngredient(ingredient)
    end
  end

  def getRecipes
    @recipe_book.getAllRecipes
  end
end