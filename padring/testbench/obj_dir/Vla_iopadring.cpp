// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vla_iopadring.h"
#include "Vla_iopadring__Syms.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vla_iopadring::Vla_iopadring(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vla_iopadring__Syms(contextp(), _vcname__, this)}
    , vss{vlSymsp->TOP.vss}
    , no_pad{vlSymsp->TOP.no_pad}
    , no_z{vlSymsp->TOP.no_z}
    , no_a{vlSymsp->TOP.no_a}
    , no_ie{vlSymsp->TOP.no_ie}
    , no_oe{vlSymsp->TOP.no_oe}
    , no_pe{vlSymsp->TOP.no_pe}
    , no_ps{vlSymsp->TOP.no_ps}
    , no_sr{vlSymsp->TOP.no_sr}
    , no_st{vlSymsp->TOP.no_st}
    , no_vdd{vlSymsp->TOP.no_vdd}
    , no_vddio{vlSymsp->TOP.no_vddio}
    , no_vssio{vlSymsp->TOP.no_vssio}
    , ea_vdd{vlSymsp->TOP.ea_vdd}
    , ea_vddio{vlSymsp->TOP.ea_vddio}
    , ea_vssio{vlSymsp->TOP.ea_vssio}
    , so_vdd{vlSymsp->TOP.so_vdd}
    , so_vddio{vlSymsp->TOP.so_vddio}
    , so_vssio{vlSymsp->TOP.so_vssio}
    , we_vdd{vlSymsp->TOP.we_vdd}
    , we_vddio{vlSymsp->TOP.we_vddio}
    , we_vssio{vlSymsp->TOP.we_vssio}
    , ea_pad{vlSymsp->TOP.ea_pad}
    , ea_z{vlSymsp->TOP.ea_z}
    , ea_a{vlSymsp->TOP.ea_a}
    , ea_ie{vlSymsp->TOP.ea_ie}
    , ea_oe{vlSymsp->TOP.ea_oe}
    , ea_pe{vlSymsp->TOP.ea_pe}
    , ea_ps{vlSymsp->TOP.ea_ps}
    , ea_sr{vlSymsp->TOP.ea_sr}
    , ea_st{vlSymsp->TOP.ea_st}
    , no_ds{vlSymsp->TOP.no_ds}
    , ea_cfg{vlSymsp->TOP.ea_cfg}
    , so_pad{vlSymsp->TOP.so_pad}
    , so_z{vlSymsp->TOP.so_z}
    , so_a{vlSymsp->TOP.so_a}
    , so_ie{vlSymsp->TOP.so_ie}
    , so_oe{vlSymsp->TOP.so_oe}
    , so_pe{vlSymsp->TOP.so_pe}
    , so_ps{vlSymsp->TOP.so_ps}
    , so_sr{vlSymsp->TOP.so_sr}
    , so_st{vlSymsp->TOP.so_st}
    , so_ds{vlSymsp->TOP.so_ds}
    , so_cfg{vlSymsp->TOP.so_cfg}
    , we_ds{vlSymsp->TOP.we_ds}
    , we_cfg{vlSymsp->TOP.we_cfg}
    , no_cfg{vlSymsp->TOP.no_cfg}
    , ea_ds{vlSymsp->TOP.ea_ds}
    , we_pad{vlSymsp->TOP.we_pad}
    , we_z{vlSymsp->TOP.we_z}
    , we_a{vlSymsp->TOP.we_a}
    , we_ie{vlSymsp->TOP.we_ie}
    , we_oe{vlSymsp->TOP.we_oe}
    , we_pe{vlSymsp->TOP.we_pe}
    , we_ps{vlSymsp->TOP.we_ps}
    , we_sr{vlSymsp->TOP.we_sr}
    , we_st{vlSymsp->TOP.we_st}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vla_iopadring::Vla_iopadring(const char* _vcname__)
    : Vla_iopadring(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vla_iopadring::~Vla_iopadring() {
    delete vlSymsp;
}

//============================================================
// Evaluation loop

void Vla_iopadring___024root___eval_initial(Vla_iopadring___024root* vlSelf);
void Vla_iopadring___024root___eval_settle(Vla_iopadring___024root* vlSelf);
void Vla_iopadring___024root___eval(Vla_iopadring___024root* vlSelf);
#ifdef VL_DEBUG
void Vla_iopadring___024root___eval_debug_assertions(Vla_iopadring___024root* vlSelf);
#endif  // VL_DEBUG
void Vla_iopadring___024root___final(Vla_iopadring___024root* vlSelf);

static void _eval_initial_loop(Vla_iopadring__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    Vla_iopadring___024root___eval_initial(&(vlSymsp->TOP));
    // Evaluate till stable
    vlSymsp->__Vm_activity = true;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial loop\n"););
        Vla_iopadring___024root___eval_settle(&(vlSymsp->TOP));
        Vla_iopadring___024root___eval(&(vlSymsp->TOP));
    } while (0);
}

void Vla_iopadring::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vla_iopadring::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vla_iopadring___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    vlSymsp->__Vm_activity = true;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        Vla_iopadring___024root___eval(&(vlSymsp->TOP));
    } while (0);
    // Evaluate cleanup
}

//============================================================
// Utilities

const char* Vla_iopadring::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

VL_ATTR_COLD void Vla_iopadring::final() {
    Vla_iopadring___024root___final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vla_iopadring::hierName() const { return vlSymsp->name(); }
const char* Vla_iopadring::modelName() const { return "Vla_iopadring"; }
unsigned Vla_iopadring::threads() const { return 1; }
std::unique_ptr<VerilatedTraceConfig> Vla_iopadring::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vla_iopadring___024root__trace_init_top(Vla_iopadring___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vla_iopadring___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vla_iopadring___024root*>(voidSelf);
    Vla_iopadring__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    Vla_iopadring___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void Vla_iopadring___024root__trace_register(Vla_iopadring___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vla_iopadring::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vla_iopadring___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
