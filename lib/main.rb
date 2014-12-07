require_relative 'unit'
require_relative 'ingredient'
require_relative 'recipe'

recipe_list = Array.new

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

		print "Enter the health on the Bulletproof scale from 1 to 7 or 0" +
			" if unknown: "
		health = gets.chomp.to_i
		package[:health] = health if health >= 1 or health <= 7

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
	recipe_list << Recipe.new(title, ingredient_array, instructions)
	puts "It's saved!"

	puts recipe_list[0]

end