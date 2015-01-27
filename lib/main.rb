require_relative "user"
require_relative "ingredient"
require_relative "recipe"
require_relative "unit"
require "yaml"

def initiate_add_recipe_dialog(user)
	loop do
		print "Add new recipe? (y/n) "
		resp = gets.downcase.chomp
		if resp == "n" then puts "Goodbye!"; break; end

		print "\nWhats the name of the recipe? "
		title = gets.chomp

		puts "\nStart input the ingredients information in this order:"
		puts "name qty unit"
		puts "example: grass-fed beef 1 lb"
		puts "when you are done type \"done\""
		
		ingredient_array = Array.new

		i = 0
		loop do
			i += 1
			puts "\nIngredient #{i}:"
			input = gets.chomp
			break if input == "done" || input == ""

			input_array = input.split
			package = Hash.new
			name = input_array[0...-2].join(" ")
			qty = input_array[-2]
			unit = input_array[-1]
			package[:name] = name
			package[:unit] = Unit.new(qty, unit)

			print "Enter the health from 1 to 7 or 0" +
				" if unknown: "
			health = gets.chomp.to_i
			package[:health] = health if health >= 1 || health <= 7

			ingredient = RecipeIngredient.new(package)

			ingredient_array << ingredient
		end

		puts "\nCool. We got"
		ingredient_array.each do |i|
			puts "#{i.unit} of #{i.name}"
		end

		puts "\nType out instructions (or leave blank):"
		instructions = gets.chomp

		# TODO: make a bool based on DB addition
		user.add_recipe(Recipe.new(title, ingredient_array, instructions))
		puts "It's saved!"

	end
end


# Pantry ingredient CRUD routines
# members: qty, unit, cost, expiration, name, health
def create_pantry_ingredient_dialog(user)
	print "\nIngredient's name: "
	name = gets.chomp
	print "\nIngredient's amount: "
	qty = gets.chomp.to_i
	print "\nIngredient's unit: "
	unit = gets.chomp
	print "\nIngredient's cost (optional):"
	cost = gets.chomp
	print "\nIngredient's expiration date (MM-DD-YYYY)(optional): "
	date = gets.chomp
	print "\nIngredients health level (0-7)(optional): "
	health = gets.chomp.to_i

  unitObj = UnitFactory.build(qty, unit)
	payload = {name: name, unit: unitObj}
	payload[:date] = Date.strptime(date, "%m-%d-%Y") if date =~ /\d{1,2}-\d{1,2}-\d{4}/
	payload[:health] = health.to_i if health =~ /^[0-7]$/
	payload[:cost] = cost.to_f if cost =~ /[0-9]*\.?[0-9]*/
	
	user.add_ingredient_to_pantry(PantryIngredient.new(payload))

	puts "Successfully added #{name} to the pantry"
rescue => e
	puts "Failed to initiate new ingredient: #{e}"
end

def save_user(user)
	yaml = YAML::dump(user)
	fname = user.name.downcase + ".yaml"
	File.new(fname, 'w').write(yaml)
end

def load_user(name)
	fname = name + ".yaml"
	yaml = File.open(fname, 'r').read
	YAML::load(yaml)
end

#userp = User.new("Paul")
#initiate_add_recipe_dialog(userp)
#save_user(userp)

userp = load_user("Paul")
userp.get_recipes.each{|r| puts r}
loop do
	create_pantry_ingredient_dialog(userp)
	save_user(userp)
end