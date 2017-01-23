require 'matrix'
require 'Logic'

CAPITAL_ALPHA = (1..26).to_a.zip(("A".."Z").to_a).to_h
STRING2BOOL = {'T'=> true, 'F'=> false}
BOOL2STRING = {false => 'F', true => 'T'}

class TruthTable

  def initialize(n_variables, variable_names=CAPITAL_ALPHA)

    @n = n_variables
    @variables = create_variable_array(@n, variable_names)

    @tt = create_initial_matrix(@n)

  end

  def print_to_console m
    @variables.each{|v| print "#{v}\t"}
  end

  def to_markdown

  end

  # Adds a Well-Formed Formula to the table
  # WFFs are given in the format: [atom, connective, atom] where atom is either a variable or another wff
  def add_wff wff

  end

  def create_variable_array(n, names)
    return (1..n).map{|x| names[x]}
  end

  def create_initial_matrix n_columns
  end
end

puts ARGV
t = TruthTable.new(ARGV[0].to_i)
puts t
