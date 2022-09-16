#!/bin/bash

# Compile and Run Icarus
iverilog tb_la_iopadring.v -y ../rtl/ -y ../../iolib/rtl -y ../../../oh/stdlib/testbench/
./a.out

# Compile Verilator
verilator ../rtl/la_iopadring.v ../rtl/la_ioside.v ../rtl/la_iosection.v  -y ../../iolib//rtl -top la_iopadring +libext+.sv+.v -cc -Wno-WIDTH --trace --debug -cc  --exe tb_la_iopadring.cpp
make -C obj_dir Vla_iopadring.mk Vla_iopadring
