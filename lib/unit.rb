# make the unit class
=begin
Volume symbols:
gal, gallon, gallons
qt, quart, quarts
pt, pint, pints
c, cup, cups
fl. oz., fl oz, fluid ounce, fluid ounces
tbsp, tablespoon, tablespoons
tsp, teaspoon, teaspoons

Weight symbols:
g, gram, grams
lb, lbs, pound, pounds
oz, ounce, ounces
=end

require 'set'

module UnitFactory
  @@volumeSet = Set.new [:gal, :qt, :pt, :c, :'fl oz', :tbsp, :tsp]
  @@weightSet = Set.new [:g, :lb, :oz]
                 
  def self.build(*args)
    if args.length == 1 then 
      qty, name = args[0].split
      qty = qty.to_f
    else qty, name = args
    end
    
    name = name.to_sym
    if @@volumeSet.include?(name)
      return volumeUnit(qty, name)
    elsif  @@weightSet.include?(name)
      return weightUnit(qty, name)
    else 
      raise ArgumentError
    end
  end

  def self.volumeUnit(qty, name)
    VolumeUnit.new(qty, name)
  end

  def self.weightUnit(qty, name)
    WeightUnit.new(qty, name)
  end

  
end

class Unit
  attr_reader :unit_name
  attr_accessor :qty
  
  def initialize(qty, unit_name)
    @qty = qty.to_f
    @unit_name = unit_name.to_sym
    initialize_procs unless defined? @@conversions
  end
  
  def initialize_procs
    #gallon procs
    gal = {
      qt:         Proc.new {|g| g * 4.0},
      pt:         Proc.new {|g| g * 8.0},
      c:          Proc.new {|g| g * 16.0},
      :'fl oz' => Proc.new {|g| g * 128.0},
      tbsp:       Proc.new {|g| g * 256.0},
      tsp:        Proc.new {|g| g * 768.0}
    }
    
    #quart procs
    qt = {
      gal:        Proc.new{|qt| qt / 4.0},
      pt:         Proc.new{|qt| qt * 2.0},
      c:          Proc.new{|qt| qt * 4.0},
      :'fl oz' => Proc.new{|qt| qt * 32.0},
      tbsp:       Proc.new{|qt| qt * 64.0},
      tsp:        Proc.new{|qt| qt * 192.0},
    }
    
    #pint procs
    pt = {
      gal:        Proc.new{|pt| pt / 8.0},
      qt:         Proc.new{|pt| pt / 2.0},
      c:          Proc.new{|pt| pt * 2.0},
      :'fl oz' => Proc.new{|pt| pt * 16.0},
      tbsp:       Proc.new{|pt| pt * 32.0},
      tsp:        Proc.new{|pt| pt * 96.0},
    }
    
    #cup procs
    c = {
      gal:        Proc.new{|c| c / 16.0 },
      qt:         Proc.new{|c| c / 4.0 },
      pt:         Proc.new{|c| c / 2.0},
      :'fl oz' => Proc.new{|c| c * 8.0},
      tbsp:       Proc.new{|c| c * 16.0},
      tsp:        Proc.new{|c| c * 48.0},
    }
    
    #fl oz procs
    fl_oz = {
      gal:  Proc.new{|oz| oz / 128.0},
      qt:   Proc.new{|oz| oz / 32.0},
      pt:   Proc.new{|oz| oz / 16.0},
      c:    Proc.new{|oz| oz / 8.0},
      tbsp: Proc.new{|oz| oz * 2.0},
      tsp:  Proc.new{|oz| oz * 6.0},
    }
    
    #tbsp procs
    tbsp = {
      gal:        Proc.new{|tbsp| tbsp / 256.0},
      qt:         Proc.new{|tbsp| tbsp / 64.0},
      pt:         Proc.new{|tbsp| tbsp / 32.0},
      c:          Proc.new{|tbsp| tbsp / 16.0},
      :'fl oz' => Proc.new{|tbsp| tbsp / 2.0},
      tsp:        Proc.new{|tbsp| tbsp / 3.0},
    }
    
    #tsp procs
    tsp = {
      gal:        Proc.new{|tsp| tsp / 768.0},
      qt:         Proc.new{|tsp| tsp / 192.0},
      pt:         Proc.new{|tsp| tsp / 96.0},
      c:          Proc.new{|tsp| tsp / 48.0},
      :'fl oz' => Proc.new{|tsp| tsp / 6.0},
      tbsp:       Proc.new{|tsp| tsp / 3.0},
    }
    
    #gram procs
    g = {
      lb: Proc.new{|g| (g / 453.592).round(1)},
      oz: Proc.new{|g| (g * 0.035274).round}}
      
    #pound procs
    lb = {
      g:  Proc.new{|lb| (lb * 453.592).round},
      oz: Proc.new{|lb| lb * 16.0}}
      
    #ounce procs
    oz = {
      lb: Proc.new{|oz| oz / 16.0},
      g:  Proc.new{|oz| round(oz * 28.3495)}}
    @@conversions = {gal: gal, qt: qt, pt: pt, c: c, :'fl oz' => fl_oz,
      tbsp: tbsp, tsp: tsp, g: g, lb: lb, oz: oz}
  end
  
  def convert_to(new_unit)
    newQty = @@conversions[unit_name][new_unit].call(qty)
    
    puts "#{newQty} #{new_unit.to_s}"
  end
  
  def convert_to!(new_unit)
    name = new_unit.to_sym
    qty = convert_to(new_unit)
  end
  
  def to_s
    return "#{qty} #{unit_name}"
  end

  private

  def name
    @name
  end

  def name=(new_name)
    @name = new_name
  end
  
end

class VolumeUnit < Unit
  attr_reader :unit_names
  attr_accessor :unit_name, :qty
  @@unit_names = Set.new [:gal, :qt, :pt, :c, :'fl oz', :tbsp, :tsp]
  
  def initialize(qty, unit_name)
    super(qty, unit_name)
  end
  
  def unit=(unit_name)
    raise ArgumentError unless @@unit_names.include?(unit_name)
    @unit_name = unit_name
  end
  
  def convert_to(new_unit)
    new_unit = new_unit.to_sym
    if not @@unit_names.include? new_unit
      raise "#{new_unit.to_s} is not a valid volume unit"
    end
    
    super(new_unit)
  end
end

class WeightUnit < Unit
  attr_reader :unit_names, :unit_name
  attr_accessor :qty
  @@unit_names = Set.new [:g, :lb, :oz]
  
  def initialize(qty, unit_name)
    super(qty, unit_name)
  end
  
  def unit=(unit_name)
    raise ArgumentError unless @@unit_names.include?(unit_name)
    @unit_name = unit_name
  end
  
  def convert_to(new_unit)
    new_unit = new_unit.to_sym
    if not @@unit_names.include? new_unit
      raise "#{new_unit.to_s} is not a valid weight unit"
    end
    
    super(new_unit)
  end
end