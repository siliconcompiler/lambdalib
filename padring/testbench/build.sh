#!/bin/bash

# Compile testbench
iverilog tb_la_iopadring.v -y ../rtl/ -y ../stub -y ../../oh/stdlib/testbench/

# Run
./a.out
