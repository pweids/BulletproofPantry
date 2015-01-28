require_relative "user"
require_relative "ingredient"
require_relative "recipe"
require_relative "unit"
require "yaml"
$debug = true

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
	fname = name.downcase + ".yaml"
	yaml = File.open(fname, 'r').read
	YAML::load(yaml)
rescue => e
	return nil
end

class Main < Shoes
  url '/', :index
  url '/dialog', :dialog
  url '/pantry', :pantry
  @@user

  def index
    stack do
      title "Bulletproof Pantry"
      para "Please enter your name:"
      @name = edit_line
      button "Enter" do
        @@user = load_user(@name.text)
        if @@user == nil
        	create = confirm("User does not exist. Create new one?")
        	if create
        		@@user = User.new(@name)
        	else
        		visit('/')
        		return
        	end
        end
        @name.text = ""
   			visit('/dialog')
      end
    end
  end

  def dialog
  	stack do
  		button("View Recipes", :width => 200)
  		button("View Pantry", :width => 200) {visit ('/pantry')}
  		button("What can I Make?", :width => 200)
  	end
  end

  def pantry
  	stack do
  		@@user.display_pantry.each do
  			|ing| para ing, " ",
  			  link("delete") {|x| 
  			  	x.parent.remove
  			  	@@user.pantry.remove_ingredient(ing)
  			  	Shoes.debug @@user.pantry if $debug
  			  }
  		end
  		flow do
	  		button("Add Ingredient") do
	  			mainwindow = self
	  			window do
	  				stack do
		  				flow do
			  				stack :width => "60%" do
									para("Ingredient's name: ")
									para("Ingredient's amount: ")
									para "Ingredient's unit: "
									para "Ingredient's cost (optional):"
									para "Ingredient's expiration date (MM-DD-YYYY)(optional): "
									para "Ingredients health level (0-7)(optional): "
								end
								stack :width => "40%" do
									@name 	= edit_line :margin_bottom => 10
									@qty 		= edit_line :margin_bottom => 10
									@unit 	= edit_line :margin_bottom => 10
									@cost 	= edit_line :margin_bottom => 10
									@date 	= edit_line :margin_bottom => 10
									@health = edit_line :margin_bottom => 10
								end
							end

							flow do
								button("Add") do
								  @unitObj = UnitFactory.build(@qty.text.to_i, @unit.text)
									payload = {name: @name.text, unit: @unitObj}
									payload[:date] = Date.strptime(@date.text, "%m-%d-%Y") if @date.text =~ /\d{1,2}-\d{1,2}-\d{4}/
									payload[:health] = @health.text.to_i if @health.text =~ /^[0-7]$/
									payload[:cost] = @cost.text.to_f if @cost.text =~ /[0-9]*\.?[0-9]*/
									
									@@user.add_ingredient_to_pantry(PantryIngredient.new(payload))
									self.close
									mainwindow.visit('/pantry')
								end

								button("Cancel") do
									self.close
								end
						end
					end
  				end
  			end

  			button("Back") do
  				visit('/dialog')
  			end
  		end
  	end
  end


end

Shoes.show_log
Shoes.app
#userp = User.new("Paul")
#initiate_add_recipe_dialog(userp)
#save_user(userp)

#userp = load_user("Paul")
#userp.get_recipes.each{|r| puts r}