class Recipe
  attr_accessor :ingredients, :title, :instructions

  def initialize(title, ingredients, instructions = "")
    @title = title
    @ingredients = Set.new
    ingredients.each {|i| @ingredients << i}
    @instructions = instructions
  end

  def getHealth
    sum = 0.0
    counter = 0
    ingredients.each do |el|
      if el.health != nil
        sum += el.health
        counter += 1
      end
    end
    average = sum / counter
    return average
  end

  def wrap(s, width=78)
    s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
  end

  def to_s
    str = ""
    max = 0
    ingredients.each do |i|
      max = [i.name.length, max].max
    end

    @ingredients.each do |i|
      str << sprintf("%s%3.2f %-4s\n", i.name.ljust(max+4, '.'), i.qty, i.unit)
    end

    str << wrap(instructions, max+14)

    str = "#{title}".center(max+11) << "\n\n" << str
    return str
  end

end