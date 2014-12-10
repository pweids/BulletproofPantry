require_relative 'unit'
require_relative 'ingredient'
require_relative 'recipe'

#TODO modify this so that it's synced with KirbyBase instead
$recipe_list = Array.new
$pantry_list = Array.new

def initiate_add_recipe_dialog
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
			break if input == "done"

			input_array = input.split
			package = Hash.new
			package[:name] = input_array[0...-2].join(" ")
			package[:qty] = input_array[-2]
			package[:unit] = input_array[-1]

			print "Enter the health from 1 to 7 or 0" +
				" if unknown: "
			health = gets.chomp.to_i
			package[:health] = health if health >= 1 || health <= 7

			ingredient = RecipeIngredient.new(package)

			ingredient_array << ingredient
		end

		puts "\nCool. We got"
		ingredient_array.each do |i|
			puts "#{i.qty} #{i.unit} of #{i.name}"
		end

		puts "\nType out instructions (or leave blank):"
		instructions = gets.chomp

		# TODO: make a bool based on DB addition
		$recipe_list << Recipe.new(title, ingredient_array, instructions)
		puts "It's saved!"

		puts recipe_list[0]

	end
end


# Pantry ingredient CRUD routines
# members: qty, unit, cost, expiration, name, health
def create_pantry_ingredient
	print "\nIngredient's name: "
	name = gets.chomp
	print "\nIngredient's amount: "
	qty = gets.chomp.to_i
	print "\nIngredient's unit: "
	unit = gets.chomp
	print "\nIngredient's expiration date (MM-DD-YYYY)(optional): "
	date = gets.chomp
	print "\nIngredients health level (0-7)(optional): "
	health = gets.chomp.to_i

  unitObj = UnitFactory.build(qty, unit)
	payload = {name: name, unit: unitObj}
	payload[:date] = Date.strptime(date, "%m-%d-%Y") if date =~ /\d{1,2}-\d{1,2}-\d{4}/
	payload[:health] = health if health =~ /^[0-7]$/
	
	$pantry_list << PantryIngredient.new(payload)

	puts "Successfully added #{name} to the pantry"
rescue => e
	puts "Failed to initiate new ingredient: #{e}"
end

def read_pantry_ingredient(ingredient = nil)
	if ingredient.kind_of? String
		$pantry_list.select{|item| item == ingredient}.each{|item| puts item}
	else
		$pantry_list.each{|item| puts item}
	end
end

def update_pantry_ingredient
end

def delete_pantry_ingredient
end