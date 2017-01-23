require 'matrix'

CAPITAL_ALPHA = (1..26).to_a.zip(("A".."Z").to_a).to_h
STRING2BOOL = {'T'=> true, 'F'=> false}
BOOL2STRING = {false => 'F', true => 'T'}

class TruthTable

  def initialize(n_variables, variable_names=CAPITAL_ALPHA)

    @n = n_variables
    @variables = create_variable_array(@n, variable_names)

    @tt = create_initial_matrix(@n)
    print_to_console @tt
    a1 = Variable.new("A")
    a2 = Variable.new("B")
    c1 = And.new
    wff1 = WFF.new(a1, c1, a2)
    puts wff1.to_s
    puts BOOL2STRING[c1.eval true, false]
    wff2 = WFF.new(wff1, Negation.new)
    puts wff2.to_s
    puts wff2.eval(wff1.eval(true, false), false)
  end

  def print_to_console m
    @variables.each{|v| print "#{v}\t"}
    print "\n"
    puts "-------" * m.column_vectors.length
    m.row_vectors.each_with_index{|r, idx| r.each{|e| print "#{e}\t"}; print "\n"}
  end

  def to_markdown

  end

  # Adds a Well-Formed Formula to the table
  # WFFs are given in the format: [atom, connective, atom] where atom is either a variable or another wff
  def add_wff wff
    truth_values = @tt.row_vectors.each{|row|

    @tt = @tt.columns(

  end

  def create_variable_array(n, names)
    return (1..n).map{|x| names[x]}
  end

  def create_initial_matrix n_columns
    return Matrix[*["T", "F"].repeated_permutation(n_columns)]
  end
end

class Atom
  def to_s
    return @symbol
  end
end

class Connective
  def to_s
    return @symbol
  end
end

class Variable < Atom
  def initialize(symbol)
    @symbol = symbol
  end
end

class WFF < Atom

  def initialize(*args)
    if args.size == 2
      puts args
      puts args.size
      raise TypeError unless (args[1].is_a? UnaryConnective and args[0].is_a? Atom)
      @atom1 = args[0]
      @connective = args[1]
    elsif args.size == 3
      puts args.size
      raise TypeError unless args[0].is_a? Atom and args[2].is_a? Atom and args[1].is_a? Connective
      @atom1 = args[0]
      @connective = args[1]
      @atom2 = args[2]
    else
      raise ArgumentError 
    end
  end

  def to_s
    if @atom2.nil?
      return "#{@connective.to_s}#{@atom1.to_s}"
    else
      return "#{@atom1.to_s}#{@connective.to_s}#{@atom2.to_s}"
    end
  end

  def eval t1, t2
    if @atom2.nil?
      return @connective.eval t1
    else
      return @connective.eval t1, t2
    end
  end
end

class And < Connective
  def initialize
    @symbol = "∧"
  end

  def eval t1, t2
    if t1 and t2
      return true
    else
      return false
    end
  end
end

class Or < Connective
  def initialize
    @symbol = "∨"
  end

  def eval t1, t2
    if t1 
      return true
    elsif t2
      return true
    else
      return false
    end
  end
end

class If < Connective
  def initialize
    @symbol = "→"
  end

  def eval t1,t2
    if t1
      if t2
        return true
      else
        return false
      end
    else
      return true
    end
  end
end

class Iff < Connective
  def initialize
    @symbol = "↔"
  end

  def eval t1, t2
    if t1
      if t2
        return true
      else
        return false
      end
    else
      if t2
        return false
      else
        return true
      end
    end
  end
end

class UnaryConnective < Connective
end

class Negation < UnaryConnective
  def initialize
    @symbol = "¬"
  end

  def eval t1
    if t1
      return false
    else
      return true
    end
  end
end

puts ARGV
t = TruthTable.new(ARGV[0].to_i)
puts t
