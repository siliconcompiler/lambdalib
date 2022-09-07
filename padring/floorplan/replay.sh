#!/bin/bash
surelog -elabuhdm -parse ../rtl/la_iopadring.v ../rtl/la_ioside.v ../rtl/la_iosection.v  -y ../../iolib/adapter/sky130io/rtl -top la_iopadring +libext+.sv+.v -timescale=1ns/1ps
