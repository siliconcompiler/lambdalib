// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary model header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef VERILATED_VLA_IOPADRING_H_
#define VERILATED_VLA_IOPADRING_H_  // guard

#include "verilated.h"

class Vla_iopadring__Syms;
class Vla_iopadring___024root;
class VerilatedVcdC;

// This class is the main interface to the Verilated model
class Vla_iopadring VL_NOT_FINAL : public VerilatedModel {
  private:
    // Symbol table holding complete model state (owned by this class)
    Vla_iopadring__Syms* const vlSymsp;

  public:

    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_INOUT8(&vss,0,0);
    VL_INOUT8(&no_pad,7,0);
    VL_OUT8(&no_z,7,0);
    VL_IN8(&no_a,7,0);
    VL_IN8(&no_ie,7,0);
    VL_IN8(&no_oe,7,0);
    VL_IN8(&no_pe,7,0);
    VL_IN8(&no_ps,7,0);
    VL_IN8(&no_sr,7,0);
    VL_IN8(&no_st,7,0);
    VL_INOUT8(&no_vdd,1,0);
    VL_INOUT8(&no_vddio,1,0);
    VL_INOUT8(&no_vssio,1,0);
    VL_INOUT8(&ea_vdd,1,0);
    VL_INOUT8(&ea_vddio,1,0);
    VL_INOUT8(&ea_vssio,1,0);
    VL_INOUT8(&so_vdd,1,0);
    VL_INOUT8(&so_vddio,1,0);
    VL_INOUT8(&so_vssio,1,0);
    VL_INOUT8(&we_vdd,1,0);
    VL_INOUT8(&we_vddio,1,0);
    VL_INOUT8(&we_vssio,1,0);
    VL_INOUT16(&ea_pad,15,0);
    VL_OUT16(&ea_z,15,0);
    VL_IN16(&ea_a,15,0);
    VL_IN16(&ea_ie,15,0);
    VL_IN16(&ea_oe,15,0);
    VL_IN16(&ea_pe,15,0);
    VL_IN16(&ea_ps,15,0);
    VL_IN16(&ea_sr,15,0);
    VL_IN16(&ea_st,15,0);
    VL_IN(&no_ds,23,0);
    VL_INW(&ea_cfg,127,0,4);
    VL_INOUT(&so_pad,31,0);
    VL_OUT(&so_z,31,0);
    VL_IN(&so_a,31,0);
    VL_IN(&so_ie,31,0);
    VL_IN(&so_oe,31,0);
    VL_IN(&so_pe,31,0);
    VL_IN(&so_ps,31,0);
    VL_IN(&so_sr,31,0);
    VL_IN(&so_st,31,0);
    VL_INW(&so_ds,95,0,3);
    VL_INW(&so_cfg,255,0,8);
    VL_INW(&we_ds,191,0,6);
    VL_INW(&we_cfg,511,0,16);
    VL_IN64(&no_cfg,63,0);
    VL_IN64(&ea_ds,47,0);
    VL_INOUT64(&we_pad,63,0);
    VL_OUT64(&we_z,63,0);
    VL_IN64(&we_a,63,0);
    VL_IN64(&we_ie,63,0);
    VL_IN64(&we_oe,63,0);
    VL_IN64(&we_pe,63,0);
    VL_IN64(&we_ps,63,0);
    VL_IN64(&we_sr,63,0);
    VL_IN64(&we_st,63,0);

    // CELLS
    // Public to allow access to /* verilator public */ items.
    // Otherwise the application code can consider these internals.

    // Root instance pointer to allow access to model internals,
    // including inlined /* verilator public_flat_* */ items.
    Vla_iopadring___024root* const rootp;

    // CONSTRUCTORS
    /// Construct the model; called by application code
    /// If contextp is null, then the model will use the default global context
    /// If name is "", then makes a wrapper with a
    /// single model invisible with respect to DPI scope names.
    explicit Vla_iopadring(VerilatedContext* contextp, const char* name = "TOP");
    explicit Vla_iopadring(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    virtual ~Vla_iopadring();
  private:
    VL_UNCOPYABLE(Vla_iopadring);  ///< Copying not allowed

  public:
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options = 0);
    /// Retrieve name of this model instance (as passed to constructor).
    const char* name() const;

    // Abstract methods from VerilatedModel
    const char* hierName() const override final;
    const char* modelName() const override final;
    unsigned threads() const override final;
    std::unique_ptr<VerilatedTraceConfig> traceConfig() const override final;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
