require './TruthTable'
require './Logic'

tt = TruthTable.new(ARGV[0].to_i)

a = tt.variables[0]
b = tt.variables[1]
disj = Or.new
wff = WFF.new(a, disj, b)
tt.add_wff(wff)
tt.print_to_console
neg = Not.new
wff2 = WFF.new(wff, neg)
tt.add_wff(wff2)
tt.print_to_console
#c = tt.variables[2]
#conj = And.new
#wff3 = WFF.new(wff2, conj, c)
#tt.add_wff(wff3)
tt.print_to_console
cond = If.new
wff4 = WFF.new(a, cond, b)
tt.add_wff(wff4)
tt.print_to_console
wff5 = WFF.new(a, neg)
tt.add_wff(wff5)
wff6 = WFF.new(wff5, disj, b)
tt.add_wff(wff6)
tt.print_to_console
puts tt.are_equivalent? wff6, wff4

TruthTable.new(ARGV[0].to_i)
