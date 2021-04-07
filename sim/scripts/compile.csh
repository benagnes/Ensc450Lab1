# Simple script for compiling a vhdl file for simulation
# fcampi@sfu.ca / atino@sfu.ca

# Cleaning the work folder (This should not be done if compiling incrementally)
rm -rf work

# Creating and mapping to logic name work the local work library
vlib work
vmap work work

# Compiling the VHDL code for simulation
vcom ../vhdl/fpupack.vhd
vcom ../vhdl/fpu_add.vhd
vcom ../vhdl/fpu_sub.vhd
vcom ../vhdl/fpu_mul.vhd
vcom ../vhdl/fpu_div.vhd
vcom ../vhdl/fpu_round.vhd
vcom ../vhdl/fpu_exceptions.vhd
vcom ../vhdl/comppack.vhd
vcom ../vhdl/fpu_double.vhd

vcom ../vhdl/fpu_double_TB.vhd #-novopt 
