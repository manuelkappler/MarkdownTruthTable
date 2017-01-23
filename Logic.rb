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
