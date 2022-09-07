// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VLA_IOPADRING__SYMS_H_
#define VERILATED_VLA_IOPADRING__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vla_iopadring.h"

// INCLUDE MODULE CLASSES
#include "Vla_iopadring___024root.h"

// SYMS CLASS (contains all model state)
class Vla_iopadring__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vla_iopadring* const __Vm_modelp;
    bool __Vm_activity = false;  ///< Used by trace routines to determine change occurred
    uint32_t __Vm_baseCode = 0;  ///< Used by trace routines when tracing multiple models
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vla_iopadring___024root        TOP;

    // CONSTRUCTORS
    Vla_iopadring__Syms(VerilatedContext* contextp, const char* namep, Vla_iopadring* modelp);
    ~Vla_iopadring__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
