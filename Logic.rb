class Atom
  def to_s
    return @symbol
  end
end

class Connective
  include Comparable

  attr_reader(:precedence)

  def to_s
    return @symbol
  end

  def <=>(other_connective)
    if self.precedence < other_connective.precedence
      return 1
    elsif self.precedence > other_connective.precedence
      return -1
    else
      return 0
    end
  end
end

class Variable < Atom
  def initialize(symbol)
    @symbol = symbol
  end
end

class WFF < Atom

  attr_reader(:atom1, :atom2)

  def initialize(*args)
    if args.size == 2
      raise TypeError unless (args[1].is_a? UnaryConnective and args[0].is_a? Atom)
      @atom1 = args[0]
      @connective = args[1]
    elsif args.size == 3
      raise TypeError unless args[0].is_a? Atom and args[2].is_a? Atom and args[1].is_a? Connective
      @atom1 = args[0]
      @connective = args[1]
      @atom2 = args[2]
    else
      raise ArgumentError 
    end
  end

  def is_unary?
    return @atom2.nil?
  end

  def to_s
    if @atom1.is_a? Variable
      a1 = @atom1.to_s
    else
      a1 = "(#{@atom1.to_s})"
    end
    if is_unary?
      return "#{@connective.to_s}#{a1}"
    else
      if @atom2.is_a? Variable
        a2 = @atom2.to_s
      else
        a2 = "(#{@atom2.to_s})"
      end
      return "#{a1}#{@connective.to_s}#{a2}"
    end
  end

  def eval(t1, t2=nil)
    if t2.nil? and @atom2.nil?
      return @connective.eval t1
    elsif (t2.nil? and not @atom2.nil?) or (@atom2.nil? and not t2.nil?)
      raise ArgumentError
    else
      return @connective.eval t1, t2
    end
  end

end

class And < Connective
  def initialize
    @precedence = 2
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
    @precedence = 3
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
    @precedence = 4
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
    @precedence = 5
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

class Not < UnaryConnective
  def initialize
    @symbol = "¬"
    @precedence = 1
  end

  def eval t1
    if t1
      return false
    else
      return true
    end
  end
end

# Dummy connective for parsing
class Sentinel < Connective
  def initialize
    @precedence = 10
  end
end
