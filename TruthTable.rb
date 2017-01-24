require './Logic'
require 'colorize'

CAPITAL_ALPHA = (1..26).to_a.zip(("A".."Z").to_a).to_h
STRING2BOOL = {'T'=> true, 'F'=> false}
BOOL2STRING = {false => 'F', true => 'T'}

class TruthTable

  # Should be a hash-like structure that has the Atoms as keys and the truth values as value

  attr_accessor(:variables)

  def initialize(variables, variable_names=CAPITAL_ALPHA)
    @names = variable_names
    if variables.is_a? Integer
      @variables = create_empty_table_for_n variables
    elsif variables.is_a? Array
      @variables = variables
    elsif variables.is_a? Hash
      @variables = variables.values
    end
    # puts @variables
    @tt = create_initial_hash(@variables)
  end

  def create_empty_table_for_n n_variables
    @n = n_variables
    @variables = create_variable_array(@n, @names)
  end

  def create_variable_array(n, names)
    return (1..n).map{|x| Variable.new(names[x])}
  end

  def create_initial_hash vars
    hash = {}
    vars.each_with_index{|v, idx| hash[v] = [true, false].repeated_permutation(vars.length).to_a.map{|x| x[idx]}}
    return hash
  end

  # Adds a Well-Formed Formula to the table
  # WFFs are given in the format: [atom, connective, atom] where atom is either a variable or another wff
  def add_wff wff
    if wff.is_unary?
      if wff.atom1.is_a? WFF
        add_wff(wff.atom1)
      end
      @tt[wff] = @tt[wff.atom1].map{|x| wff.eval x}
    elsif wff.atom1.is_a? WFF and wff.atom2.is_a? WFF
      add_wff(wff.atom2)
      @tt[wff] = @tt[wff.atom1].each_with_index.map{|x, idx| wff.eval(x, @tt[wff.atom2][idx])}
    elsif wff.atom1.is_a? WFF
      add_wff(wff.atom1)
      @tt[wff] = @tt[wff.atom1].each_with_index.map{|x, idx| wff.eval(x, @tt[wff.atom2][idx])}
    elsif wff.atom2.is_a? WFF
      @tt[wff] = @tt[wff.atom1].each_with_index.map{|x, idx| wff.eval(x, @tt[wff.atom2][idx])}
    else
      @tt[wff] = @tt[wff.atom1].each_with_index.map{|x, idx| wff.eval(x, @tt[wff.atom2][idx])}
    end
  end

  def get_row tt, row
    tt.keys.map{|col| tt[col][row]}
  end

  # Printing etc.
   
  def print_to_console
    @tt.keys.each{|v| print "#{v.to_s}"; print "\t" * (2 - v.to_s.length / 7)}
    puts "\n"
    puts "—————\t\t" * @tt.keys.length
    0.upto(@tt.values[0].length - 1) do |row_index|
      get_row(@tt, row_index).each{|x| print "#{x ? x.to_s.green : x.to_s.red}\t\t"}
      print "\n"
    end
  end 

  def print_wffs array_of_wffs_to_print, print_variables=true
    if print_variables
      array_of_wffs_to_print = @variables | array_of_wffs_to_print 
      #puts array_of_wffs_to_print
    end
    array_of_wffs_to_print.each do |v|
      begin
        @tt[v]
      rescue
        raise ArgumentError
      end
      print "#{v.to_s}"; 
      print "\t" * (2 - v.to_s.length / 7)
    end
    puts "\n"
    
    0.upto(@tt.values[0].length - 1) do |row_index|
      array_of_wffs_to_print.each do |v|
        value = @tt[v][row_index]
        print "#{value ? value.to_s.green : value.to_s.red}\t\t"
      end
      print "\n"
    end
  end

  def to_markdown

  end

  def are_equivalent? wff1, wff2
    begin
      return @tt[wff1] == @tt[wff2]
    rescue
      raise KeyError
    end
  end

end
