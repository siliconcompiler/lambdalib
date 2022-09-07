// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vla_iopadring.h for the primary calling header

#ifndef VERILATED_VLA_IOPADRING___024ROOT_H_
#define VERILATED_VLA_IOPADRING___024ROOT_H_  // guard

#include "verilated.h"

class Vla_iopadring__Syms;

class Vla_iopadring___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    // Anonymous structures to workaround compiler member-count bugs
    struct {
        VL_INOUT8(vss,0,0);
        VL_INOUT8(no_pad,7,0);
        VL_OUT8(no_z,7,0);
        VL_IN8(no_a,7,0);
        VL_IN8(no_ie,7,0);
        VL_IN8(no_oe,7,0);
        VL_IN8(no_pe,7,0);
        VL_IN8(no_ps,7,0);
        VL_IN8(no_sr,7,0);
        VL_IN8(no_st,7,0);
        VL_INOUT8(no_vdd,1,0);
        VL_INOUT8(no_vddio,1,0);
        VL_INOUT8(no_vssio,1,0);
        VL_INOUT8(ea_vdd,1,0);
        VL_INOUT8(ea_vddio,1,0);
        VL_INOUT8(ea_vssio,1,0);
        VL_INOUT8(so_vdd,1,0);
        VL_INOUT8(so_vddio,1,0);
        VL_INOUT8(so_vssio,1,0);
        VL_INOUT8(we_vdd,1,0);
        VL_INOUT8(we_vddio,1,0);
        VL_INOUT8(we_vssio,1,0);
        CData/*2:0*/ la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z;
        CData/*3:0*/ la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z;
        CData/*7:0*/ la_iopadring__DOT__inorth__DOT__pad__out__out72;
        CData/*7:0*/ la_iopadring__DOT__inorth__DOT__pad__out__out73;
        CData/*0:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__1__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioxtal__BRA__2__KET____DOT__i0__z;
        CData/*2:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48;
        CData/*0:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__2__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__3__KET____DOT__i0__z;
        CData/*3:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79;
        CData/*3:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80;
        CData/*2:0*/ la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z;
        CData/*3:0*/ la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__1__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioxtal__BRA__2__KET____DOT__i0__z;
        CData/*2:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48;
        CData/*0:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__2__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__3__KET____DOT__i0__z;
        CData/*3:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79;
        CData/*3:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80;
        CData/*2:0*/ la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z;
        CData/*3:0*/ la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__1__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioxtal__BRA__2__KET____DOT__i0__z;
        CData/*2:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48;
        CData/*0:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__2__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__3__KET____DOT__i0__z;
        CData/*3:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79;
        CData/*3:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80;
        CData/*2:0*/ la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z;
        CData/*3:0*/ la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__1__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioxtal__BRA__2__KET____DOT__i0__z;
        CData/*2:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48;
        CData/*0:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__2__KET____DOT__i0__z;
        CData/*0:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__3__KET____DOT__i0__z;
        CData/*3:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79;
        CData/*3:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80;
        VL_INOUT16(ea_pad,15,0);
        VL_OUT16(ea_z,15,0);
        VL_IN16(ea_a,15,0);
        VL_IN16(ea_ie,15,0);
    };
    struct {
        VL_IN16(ea_oe,15,0);
        VL_IN16(ea_pe,15,0);
        VL_IN16(ea_ps,15,0);
        VL_IN16(ea_sr,15,0);
        VL_IN16(ea_st,15,0);
        SData/*15:0*/ la_iopadring__DOT__ieast__DOT__pad__out__out44;
        SData/*15:0*/ la_iopadring__DOT__ieast__DOT__pad__out__out45;
        VL_IN(no_ds,23,0);
        VL_INW(ea_cfg,127,0,4);
        VL_INOUT(so_pad,31,0);
        VL_OUT(so_z,31,0);
        VL_IN(so_a,31,0);
        VL_IN(so_ie,31,0);
        VL_IN(so_oe,31,0);
        VL_IN(so_pe,31,0);
        VL_IN(so_ps,31,0);
        VL_IN(so_sr,31,0);
        VL_IN(so_st,31,0);
        VL_INW(so_ds,95,0,3);
        VL_INW(so_cfg,255,0,8);
        VL_INW(we_ds,191,0,6);
        VL_INW(we_cfg,511,0,16);
        IData/*31:0*/ la_iopadring__DOT__isouth__DOT__pad__out__out44;
        IData/*31:0*/ la_iopadring__DOT__isouth__DOT__pad__out__out45;
        VL_IN64(no_cfg,63,0);
        VL_IN64(ea_ds,47,0);
        VL_INOUT64(we_pad,63,0);
        VL_OUT64(we_z,63,0);
        VL_IN64(we_a,63,0);
        VL_IN64(we_ie,63,0);
        VL_IN64(we_oe,63,0);
        VL_IN64(we_pe,63,0);
        VL_IN64(we_ps,63,0);
        VL_IN64(we_sr,63,0);
        VL_IN64(we_st,63,0);
        QData/*63:0*/ la_iopadring__DOT__iwest__DOT__pad__out__out68;
        QData/*63:0*/ la_iopadring__DOT__iwest__DOT__pad__out__out69;
        VlUnpacked<CData/*0:0*/, 2> __Vm_traceActivity;
    };

    // INTERNAL VARIABLES
    Vla_iopadring__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vla_iopadring___024root(Vla_iopadring__Syms* symsp, const char* name);
    ~Vla_iopadring___024root();
    VL_UNCOPYABLE(Vla_iopadring___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
