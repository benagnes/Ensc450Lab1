vsim fpu_double_tb
restart -f
# Run Init time (Time needed to put the system in a consistent state, but that you don't want to measure. For example reset time, operand read, etc)
run 200 ns

#vcd add -file rgb2gray.vcd -r /e/uut/* 
vcd add -file fpu_double_backend.vcd -r /fpu_double_tb/UUT/*

# Run VCD time, depending on how long is the period you want to run your power analysis upon #  # 24900 ns
run 3000ns

# Closes vcd file
vcd flush fpu_double_backend.vcd
vcd2saif -input fpu_double_backend.vcd -output fpu_double_backend.vcd.saif
#vcd flush rgb2gray.vcd
#vcd2saif -input rgb2gray.vcd -output rgb2gray.vcd.saif 
