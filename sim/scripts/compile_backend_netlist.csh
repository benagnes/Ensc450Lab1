# Simple script for compiling a vhdl file for simulation
# fcampi@sfu.ca

# Cleaning the work folder (This should not be done if compiling incrementally)
rm -rf work

# Creating and mapping to logic name work the local work library
vlib work
vmap work work

# Compiling the VHDL code for simulation
vlog /CMC/setups/ensc450/SOCLAB/LIBRARIES/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/Verilog/NangateOpenCellLibrary.v

vcom ../vhdl/fpupack.vhd

#vcom ../vhdl/fpu_add.vhd
#vlog ../syn_045/results/fpu_add.ref.v 

#vcom ../vhdl/fpu_sub.vhd
#vlog ../syn_045/results/fpu_sub.ref.v 

#vcom ../vhdl/fpu_mul.vhd
#vlog ../syn_045/results/fpu_mul.ref.v 

#vcom ../vhdl/fpu_round.vhd
#vlog ../syn_045/results/fpu_round.ref.v 

#vcom ../vhdl/fpu_exceptions.vhd
#vlog ../syn_045/results/fpu_exceptions.ref.v 

vcom ../vhdl/comppack.vhd

#vcom ../vhdl/fpu_double.vhd
#vlog /local-scratch/localhome/escmc38/Desktop/ensc450/fpu_double_backend/BE_045/results/verilog/fpu_double.final.v
vlog /local-scratch/localhome/escmc38/Desktop/ensc450/fpu_double_backend/BE_045/PR_96density_tuned_16ns/results/verilog/fpu_double.final.v

vcom ../vhdl/fpu_double_TB.vhd #-novopt 

#vcom ../vhdl/txt_util.vhd #-novopt 
#vcom ../vhdl/fpu_double_TB2.vhd #-novopt 

