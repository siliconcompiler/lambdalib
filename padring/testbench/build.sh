#!/bin/bash

# Compile and Run Icarus
iverilog tb_la_iopadring.v -y ../rtl/ -y ../../iolib/rtl -I../rtl/
./a.out
