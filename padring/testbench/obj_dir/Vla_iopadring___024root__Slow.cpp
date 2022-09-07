// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vla_iopadring.h for the primary calling header

#include "verilated.h"

#include "Vla_iopadring__Syms.h"
#include "Vla_iopadring___024root.h"

void Vla_iopadring___024root___ctor_var_reset(Vla_iopadring___024root* vlSelf);

Vla_iopadring___024root::Vla_iopadring___024root(Vla_iopadring__Syms* symsp, const char* name)
    : VerilatedModule{name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vla_iopadring___024root___ctor_var_reset(this);
}

void Vla_iopadring___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vla_iopadring___024root::~Vla_iopadring___024root() {
}
