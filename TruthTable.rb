require 'matrix'
require './Logic'

CAPITAL_ALPHA = (1..26).to_a.zip(("A".."Z").to_a).to_h
STRING2BOOL = {'T'=> true, 'F'=> false}
BOOL2STRING = {false => 'F', true => 'T'}

class TruthTable

  # Should be a hash-like structure that has the Atoms as keys and the truth values as value

  def initialize(n_variables, variable_names=CAPITAL_ALPHA)

    @n = n_variables
    @variables = create_variable_array(@n, variable_names)
    puts @variables
    @tt = create_initial_hash(@variables)
    print_to_console @tt

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

  end

  def get_row tt, row
    tt.keys.map{|col| tt[col][row]}
  end

  # Printing etc.
   
  def print_to_console tt
    tt.keys.each{|v| print "#{v.to_s}\t"}
    puts "\n"
    puts "———————" * tt.keys.length
    0.upto(tt.values[0].length - 1) do |row_index|
      get_row(tt, row_index).each{|x| print "#{x}\t"}
      print "\n"
    end
  end

  def to_markdown

  end


end

puts ARGV
t = TruthTable.new(ARGV[0].to_i)
puts t
