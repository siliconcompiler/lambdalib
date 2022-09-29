#!/bin/bash

# Compile and Run Icarus
echo "Icarus sim"
iverilog tb_la_iopadring.v -y ../rtl/ -y ../../iolib/rtl -I../rtl/
./a.out

# Linting with verilator
echo "Verilator linting"
verilator tb_la_iopadring.v -y ../rtl/ -y ../../iolib/rtl -I../rtl/ --lint-only -Wno-WIDTH
