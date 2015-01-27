class Pantry
  def initialize
    @stock = Array.new
  end

  def what_can_I_make?(recipe_book)
    recipe_book.select {|recipe| can_I_make?(recipe)}
  end

  def can_I_make?(recipe)
    recipe.ingredients.each{|ing| return false if !@stock.include?(ing)}
    return true
  end

  def what_ingredients_are_missing_in?(recipe)
    recipe.ingredients.select{|item| !@stock.include?(item)}
  end

  def what_is_expired?
    @stock.select{|item| item.is_expired?}
  end

  def add_ingredient(ingredient)
    @stock << ingredient
  end

  def remove_ingredient(ingredient)
  end

  def update_ingredient(ingredient)
  end

  def display_ingredients
    puts "\nPantry:\n"
    @stock.each{|item| puts item}
  end

  def find_ingredient(name)
    @stock.select{|item| item == name}
  end
end