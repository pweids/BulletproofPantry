
“Bulletproof Pantry” Design

Problem
I don’t know what is in my cabinets, how much I have, and how fresh it is. This makes it difficult to build recipes. If I knew this, I could figure out what I could make and what I could make with few new ingredients.

I also have no way of understanding what I can make based on what I have.

It takes me a while to find a recipe, figure out what I need, and then get the rest of the food.

Sometimes I just can’t decide what to make and would like a randomizer to do it for me.


Requirements
Functional
INPUTS
Item (user, string, non-null)
Qty (user, number)
Unit of measurement (user, number, positive)
Cost (float)
Health (1-7 score, null accepted)

OUTPUTS
Out of stock items
Low items
Recipes based on items
Expired items



Classes
Ingredient
Variables
float qty
string name
enum displayUnit
int health
datetime expiration
cost (null default)
compare override
methods:
getters & setters
convert quantities (static)
isExpired?
isEmpty?

Recipe
Variables
ingredients (list of objects?)



—— scratch
Give insight into my food inventory, quantities, and healthiness to assist in building recipes.

In Words:

Store and provide a list of ingredients I have in stock. 
—> Allow for the addition, removal, and qty update of some ingredients. 
—> Tell me when something expires.
—> Tell me how healthy it is
—> Convert the amount into different measurements
—> Tell me the cost
—> Search based on name, health, category, price, etc…

I also want some recipes I can use
—> Tell me how healthy the recipe is
—> Tell me what ingredients I am missing
—> Tell me what I can make, or what I can make with 1 more recipe
—> Show me cheapest recipes
—> Show me quickest recipes






Future plans
Plug ingredients into FreshDirect API
Build a list of meals that minimizes ingredients
Get recipes from Epicurious or somewhere else
Build mobile web interface for my iPhone when on the go
Build GUI 