require_relative "recipe"
require_relative "ingredient"

class RecipeBook
  include Enumerable
  def initialize
    @recipes = Array.new
  end

  def each &block
    @recipes.each(&block)
  end

  def select &block
    @recipes.select(&block)
  end

  def add_recipe(recipe)
    @recipes << recipe
  end

  def get_recipe(name)
    ret = @recipes.select{|r| r.title.include? name}
    if ret.length == 1
      ret[0]
    else ret
    end
  end

  def get_all_recipes
    @recipes
  end
end