// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vla_iopadring__Syms.h"


void Vla_iopadring___024root__trace_chg_sub_0(Vla_iopadring___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vla_iopadring___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vla_iopadring___024root__trace_chg_top_0\n"); );
    // Init
    Vla_iopadring___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vla_iopadring___024root*>(voidSelf);
    Vla_iopadring__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vla_iopadring___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void Vla_iopadring___024root__trace_chg_sub_0(Vla_iopadring___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vla_iopadring__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vla_iopadring___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgCData(oldp+0,(vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z),3);
        bufp->chgCData(oldp+1,(vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z),4);
        bufp->chgCData(oldp+2,(vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z),3);
        bufp->chgCData(oldp+3,(vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z),4);
        bufp->chgCData(oldp+4,(vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z),3);
        bufp->chgCData(oldp+5,(vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z),4);
        bufp->chgCData(oldp+6,(vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z),3);
        bufp->chgCData(oldp+7,(vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z),4);
    }
    bufp->chgBit(oldp+8,(vlSelf->vss));
    bufp->chgCData(oldp+9,(vlSelf->no_pad),8);
    bufp->chgCData(oldp+10,(vlSelf->no_z),8);
    bufp->chgCData(oldp+11,(vlSelf->no_a),8);
    bufp->chgCData(oldp+12,(vlSelf->no_ie),8);
    bufp->chgCData(oldp+13,(vlSelf->no_oe),8);
    bufp->chgCData(oldp+14,(vlSelf->no_pe),8);
    bufp->chgCData(oldp+15,(vlSelf->no_ps),8);
    bufp->chgCData(oldp+16,(vlSelf->no_sr),8);
    bufp->chgCData(oldp+17,(vlSelf->no_st),8);
    bufp->chgIData(oldp+18,(vlSelf->no_ds),24);
    bufp->chgQData(oldp+19,(vlSelf->no_cfg),64);
    bufp->chgCData(oldp+21,(vlSelf->no_vdd),2);
    bufp->chgCData(oldp+22,(vlSelf->no_vddio),2);
    bufp->chgCData(oldp+23,(vlSelf->no_vssio),2);
    bufp->chgSData(oldp+24,(vlSelf->ea_pad),16);
    bufp->chgSData(oldp+25,(vlSelf->ea_z),16);
    bufp->chgSData(oldp+26,(vlSelf->ea_a),16);
    bufp->chgSData(oldp+27,(vlSelf->ea_ie),16);
    bufp->chgSData(oldp+28,(vlSelf->ea_oe),16);
    bufp->chgSData(oldp+29,(vlSelf->ea_pe),16);
    bufp->chgSData(oldp+30,(vlSelf->ea_ps),16);
    bufp->chgSData(oldp+31,(vlSelf->ea_sr),16);
    bufp->chgSData(oldp+32,(vlSelf->ea_st),16);
    bufp->chgQData(oldp+33,(vlSelf->ea_ds),48);
    bufp->chgWData(oldp+35,(vlSelf->ea_cfg),128);
    bufp->chgCData(oldp+39,(vlSelf->ea_vdd),2);
    bufp->chgCData(oldp+40,(vlSelf->ea_vddio),2);
    bufp->chgCData(oldp+41,(vlSelf->ea_vssio),2);
    bufp->chgIData(oldp+42,(vlSelf->so_pad),32);
    bufp->chgIData(oldp+43,(vlSelf->so_z),32);
    bufp->chgIData(oldp+44,(vlSelf->so_a),32);
    bufp->chgIData(oldp+45,(vlSelf->so_ie),32);
    bufp->chgIData(oldp+46,(vlSelf->so_oe),32);
    bufp->chgIData(oldp+47,(vlSelf->so_pe),32);
    bufp->chgIData(oldp+48,(vlSelf->so_ps),32);
    bufp->chgIData(oldp+49,(vlSelf->so_sr),32);
    bufp->chgIData(oldp+50,(vlSelf->so_st),32);
    bufp->chgWData(oldp+51,(vlSelf->so_ds),96);
    bufp->chgWData(oldp+54,(vlSelf->so_cfg),256);
    bufp->chgCData(oldp+62,(vlSelf->so_vdd),2);
    bufp->chgCData(oldp+63,(vlSelf->so_vddio),2);
    bufp->chgCData(oldp+64,(vlSelf->so_vssio),2);
    bufp->chgQData(oldp+65,(vlSelf->we_pad),64);
    bufp->chgQData(oldp+67,(vlSelf->we_z),64);
    bufp->chgQData(oldp+69,(vlSelf->we_a),64);
    bufp->chgQData(oldp+71,(vlSelf->we_ie),64);
    bufp->chgQData(oldp+73,(vlSelf->we_oe),64);
    bufp->chgQData(oldp+75,(vlSelf->we_pe),64);
    bufp->chgQData(oldp+77,(vlSelf->we_ps),64);
    bufp->chgQData(oldp+79,(vlSelf->we_sr),64);
    bufp->chgQData(oldp+81,(vlSelf->we_st),64);
    bufp->chgWData(oldp+83,(vlSelf->we_ds),192);
    bufp->chgWData(oldp+89,(vlSelf->we_cfg),512);
    bufp->chgCData(oldp+105,(vlSelf->we_vdd),2);
    bufp->chgCData(oldp+106,(vlSelf->we_vddio),2);
    bufp->chgCData(oldp+107,(vlSelf->we_vssio),2);
    bufp->chgCData(oldp+108,((7U & (IData)(vlSelf->ea_pad))),3);
    bufp->chgCData(oldp+109,((7U & (IData)(vlSelf->ea_a))),3);
    bufp->chgCData(oldp+110,((7U & (IData)(vlSelf->ea_ie))),3);
    bufp->chgCData(oldp+111,((7U & (IData)(vlSelf->ea_oe))),3);
    bufp->chgCData(oldp+112,((7U & (IData)(vlSelf->ea_pe))),3);
    bufp->chgCData(oldp+113,((7U & (IData)(vlSelf->ea_ps))),3);
    bufp->chgCData(oldp+114,((7U & (IData)(vlSelf->ea_sr))),3);
    bufp->chgCData(oldp+115,((7U & (IData)(vlSelf->ea_st))),3);
    bufp->chgSData(oldp+116,((0x1ffU & (IData)(vlSelf->ea_ds))),9);
    bufp->chgIData(oldp+117,((0xffffffU & vlSelf->ea_cfg[0U])),24);
    bufp->chgBit(oldp+118,((1U & ((IData)(vlSelf->ea_pad) 
                                  >> 1U))));
    bufp->chgBit(oldp+119,((1U & ((IData)(vlSelf->ea_a) 
                                  >> 1U))));
    bufp->chgBit(oldp+120,((1U & (IData)(vlSelf->ea_pad))));
    bufp->chgBit(oldp+121,((1U & (IData)(vlSelf->ea_a))));
    bufp->chgBit(oldp+122,((1U & ((IData)(vlSelf->ea_ie) 
                                  & (IData)(vlSelf->ea_pad)))));
    bufp->chgBit(oldp+123,((1U & (IData)(vlSelf->ea_ie))));
    bufp->chgBit(oldp+124,((1U & (IData)(vlSelf->ea_oe))));
    bufp->chgBit(oldp+125,((1U & (IData)(vlSelf->ea_pe))));
    bufp->chgBit(oldp+126,((1U & (IData)(vlSelf->ea_ps))));
    bufp->chgBit(oldp+127,((1U & (IData)(vlSelf->ea_sr))));
    bufp->chgBit(oldp+128,((1U & (IData)(vlSelf->ea_st))));
    bufp->chgCData(oldp+129,((7U & (IData)(vlSelf->ea_ds))),3);
    bufp->chgCData(oldp+130,((0xffU & vlSelf->ea_cfg[0U])),8);
    bufp->chgBit(oldp+131,((1U & ((IData)(vlSelf->ea_pad) 
                                  >> 2U))));
    bufp->chgBit(oldp+132,((1U & ((IData)(vlSelf->ea_a) 
                                  >> 2U))));
    bufp->chgCData(oldp+133,((0xfU & ((IData)(vlSelf->ea_pad) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+134,((0xfU & ((IData)(vlSelf->ea_a) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+135,((0xfU & ((IData)(vlSelf->ea_ie) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+136,((0xfU & ((IData)(vlSelf->ea_oe) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+137,((0xfU & ((IData)(vlSelf->ea_pe) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+138,((0xfU & ((IData)(vlSelf->ea_ps) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+139,((0xfU & ((IData)(vlSelf->ea_sr) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+140,((0xfU & ((IData)(vlSelf->ea_st) 
                                      >> 3U))),4);
    bufp->chgSData(oldp+141,((0xfffU & (IData)((vlSelf->ea_ds 
                                                >> 9U)))),12);
    bufp->chgIData(oldp+142,(((vlSelf->ea_cfg[1U] << 8U) 
                              | (vlSelf->ea_cfg[0U] 
                                 >> 0x18U))),32);
    bufp->chgBit(oldp+143,((1U & ((IData)(vlSelf->ea_pad) 
                                  >> 5U))));
    bufp->chgBit(oldp+144,((1U & ((IData)(vlSelf->ea_a) 
                                  >> 5U))));
    bufp->chgBit(oldp+145,((1U & ((IData)(vlSelf->ea_pad) 
                                  >> 6U))));
    bufp->chgBit(oldp+146,((1U & ((IData)(vlSelf->ea_a) 
                                  >> 6U))));
    bufp->chgBit(oldp+147,((1U & ((IData)(vlSelf->ea_pad) 
                                  >> 3U))));
    bufp->chgBit(oldp+148,((1U & ((IData)(vlSelf->ea_a) 
                                  >> 3U))));
    bufp->chgBit(oldp+149,((1U & (((IData)(vlSelf->ea_ie) 
                                   & (IData)(vlSelf->ea_pad)) 
                                  >> 3U))));
    bufp->chgBit(oldp+150,((1U & ((IData)(vlSelf->ea_ie) 
                                  >> 3U))));
    bufp->chgBit(oldp+151,((1U & ((IData)(vlSelf->ea_oe) 
                                  >> 3U))));
    bufp->chgBit(oldp+152,((1U & ((IData)(vlSelf->ea_pe) 
                                  >> 3U))));
    bufp->chgBit(oldp+153,((1U & ((IData)(vlSelf->ea_ps) 
                                  >> 3U))));
    bufp->chgBit(oldp+154,((1U & ((IData)(vlSelf->ea_sr) 
                                  >> 3U))));
    bufp->chgBit(oldp+155,((1U & ((IData)(vlSelf->ea_st) 
                                  >> 3U))));
    bufp->chgCData(oldp+156,((7U & (IData)((vlSelf->ea_ds 
                                            >> 9U)))),3);
    bufp->chgCData(oldp+157,((vlSelf->ea_cfg[0U] >> 0x18U)),8);
    bufp->chgBit(oldp+158,((1U & ((IData)(vlSelf->ea_pad) 
                                  >> 4U))));
    bufp->chgBit(oldp+159,((1U & ((IData)(vlSelf->ea_a) 
                                  >> 4U))));
    bufp->chgBit(oldp+160,((1U & (((IData)(vlSelf->ea_ie) 
                                   & (IData)(vlSelf->ea_pad)) 
                                  >> 4U))));
    bufp->chgBit(oldp+161,((1U & ((IData)(vlSelf->ea_ie) 
                                  >> 4U))));
    bufp->chgBit(oldp+162,((1U & ((IData)(vlSelf->ea_oe) 
                                  >> 4U))));
    bufp->chgBit(oldp+163,((1U & ((IData)(vlSelf->ea_pe) 
                                  >> 4U))));
    bufp->chgBit(oldp+164,((1U & ((IData)(vlSelf->ea_ps) 
                                  >> 4U))));
    bufp->chgBit(oldp+165,((1U & ((IData)(vlSelf->ea_sr) 
                                  >> 4U))));
    bufp->chgBit(oldp+166,((1U & ((IData)(vlSelf->ea_st) 
                                  >> 4U))));
    bufp->chgCData(oldp+167,((7U & (IData)((vlSelf->ea_ds 
                                            >> 0xcU)))),3);
    bufp->chgCData(oldp+168,((0xffU & vlSelf->ea_cfg[1U])),8);
    bufp->chgCData(oldp+169,((7U & (IData)(vlSelf->no_pad))),3);
    bufp->chgCData(oldp+170,((7U & (IData)(vlSelf->no_a))),3);
    bufp->chgCData(oldp+171,((7U & (IData)(vlSelf->no_ie))),3);
    bufp->chgCData(oldp+172,((7U & (IData)(vlSelf->no_oe))),3);
    bufp->chgCData(oldp+173,((7U & (IData)(vlSelf->no_pe))),3);
    bufp->chgCData(oldp+174,((7U & (IData)(vlSelf->no_ps))),3);
    bufp->chgCData(oldp+175,((7U & (IData)(vlSelf->no_sr))),3);
    bufp->chgCData(oldp+176,((7U & (IData)(vlSelf->no_st))),3);
    bufp->chgSData(oldp+177,((0x1ffU & vlSelf->no_ds)),9);
    bufp->chgIData(oldp+178,((0xffffffU & (IData)(vlSelf->no_cfg))),24);
    bufp->chgBit(oldp+179,((1U & ((IData)(vlSelf->no_pad) 
                                  >> 1U))));
    bufp->chgBit(oldp+180,((1U & ((IData)(vlSelf->no_a) 
                                  >> 1U))));
    bufp->chgBit(oldp+181,((1U & (IData)(vlSelf->no_pad))));
    bufp->chgBit(oldp+182,((1U & (IData)(vlSelf->no_a))));
    bufp->chgBit(oldp+183,((1U & ((IData)(vlSelf->no_ie) 
                                  & (IData)(vlSelf->no_pad)))));
    bufp->chgBit(oldp+184,((1U & (IData)(vlSelf->no_ie))));
    bufp->chgBit(oldp+185,((1U & (IData)(vlSelf->no_oe))));
    bufp->chgBit(oldp+186,((1U & (IData)(vlSelf->no_pe))));
    bufp->chgBit(oldp+187,((1U & (IData)(vlSelf->no_ps))));
    bufp->chgBit(oldp+188,((1U & (IData)(vlSelf->no_sr))));
    bufp->chgBit(oldp+189,((1U & (IData)(vlSelf->no_st))));
    bufp->chgCData(oldp+190,((7U & vlSelf->no_ds)),3);
    bufp->chgCData(oldp+191,((0xffU & (IData)(vlSelf->no_cfg))),8);
    bufp->chgBit(oldp+192,((1U & ((IData)(vlSelf->no_pad) 
                                  >> 2U))));
    bufp->chgBit(oldp+193,((1U & ((IData)(vlSelf->no_a) 
                                  >> 2U))));
    bufp->chgCData(oldp+194,((0xfU & ((IData)(vlSelf->no_pad) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+195,((0xfU & ((IData)(vlSelf->no_a) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+196,((0xfU & ((IData)(vlSelf->no_ie) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+197,((0xfU & ((IData)(vlSelf->no_oe) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+198,((0xfU & ((IData)(vlSelf->no_pe) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+199,((0xfU & ((IData)(vlSelf->no_ps) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+200,((0xfU & ((IData)(vlSelf->no_sr) 
                                      >> 3U))),4);
    bufp->chgCData(oldp+201,((0xfU & ((IData)(vlSelf->no_st) 
                                      >> 3U))),4);
    bufp->chgSData(oldp+202,((0xfffU & (vlSelf->no_ds 
                                        >> 9U))),12);
    bufp->chgIData(oldp+203,((IData)((vlSelf->no_cfg 
                                      >> 0x18U))),32);
    bufp->chgBit(oldp+204,((1U & ((IData)(vlSelf->no_pad) 
                                  >> 5U))));
    bufp->chgBit(oldp+205,((1U & ((IData)(vlSelf->no_a) 
                                  >> 5U))));
    bufp->chgBit(oldp+206,((1U & ((IData)(vlSelf->no_pad) 
                                  >> 6U))));
    bufp->chgBit(oldp+207,((1U & ((IData)(vlSelf->no_a) 
                                  >> 6U))));
    bufp->chgBit(oldp+208,((1U & ((IData)(vlSelf->no_pad) 
                                  >> 3U))));
    bufp->chgBit(oldp+209,((1U & ((IData)(vlSelf->no_a) 
                                  >> 3U))));
    bufp->chgBit(oldp+210,((1U & (((IData)(vlSelf->no_ie) 
                                   & (IData)(vlSelf->no_pad)) 
                                  >> 3U))));
    bufp->chgBit(oldp+211,((1U & ((IData)(vlSelf->no_ie) 
                                  >> 3U))));
    bufp->chgBit(oldp+212,((1U & ((IData)(vlSelf->no_oe) 
                                  >> 3U))));
    bufp->chgBit(oldp+213,((1U & ((IData)(vlSelf->no_pe) 
                                  >> 3U))));
    bufp->chgBit(oldp+214,((1U & ((IData)(vlSelf->no_ps) 
                                  >> 3U))));
    bufp->chgBit(oldp+215,((1U & ((IData)(vlSelf->no_sr) 
                                  >> 3U))));
    bufp->chgBit(oldp+216,((1U & ((IData)(vlSelf->no_st) 
                                  >> 3U))));
    bufp->chgCData(oldp+217,((7U & (vlSelf->no_ds >> 9U))),3);
    bufp->chgCData(oldp+218,((0xffU & (IData)((vlSelf->no_cfg 
                                               >> 0x18U)))),8);
    bufp->chgBit(oldp+219,((1U & ((IData)(vlSelf->no_pad) 
                                  >> 4U))));
    bufp->chgBit(oldp+220,((1U & ((IData)(vlSelf->no_a) 
                                  >> 4U))));
    bufp->chgBit(oldp+221,((1U & (((IData)(vlSelf->no_ie) 
                                   & (IData)(vlSelf->no_pad)) 
                                  >> 4U))));
    bufp->chgBit(oldp+222,((1U & ((IData)(vlSelf->no_ie) 
                                  >> 4U))));
    bufp->chgBit(oldp+223,((1U & ((IData)(vlSelf->no_oe) 
                                  >> 4U))));
    bufp->chgBit(oldp+224,((1U & ((IData)(vlSelf->no_pe) 
                                  >> 4U))));
    bufp->chgBit(oldp+225,((1U & ((IData)(vlSelf->no_ps) 
                                  >> 4U))));
    bufp->chgBit(oldp+226,((1U & ((IData)(vlSelf->no_sr) 
                                  >> 4U))));
    bufp->chgBit(oldp+227,((1U & ((IData)(vlSelf->no_st) 
                                  >> 4U))));
    bufp->chgCData(oldp+228,((7U & (vlSelf->no_ds >> 0xcU))),3);
    bufp->chgCData(oldp+229,((0xffU & (IData)((vlSelf->no_cfg 
                                               >> 0x20U)))),8);
    bufp->chgCData(oldp+230,((7U & vlSelf->so_pad)),3);
    bufp->chgCData(oldp+231,((7U & vlSelf->so_a)),3);
    bufp->chgCData(oldp+232,((7U & vlSelf->so_ie)),3);
    bufp->chgCData(oldp+233,((7U & vlSelf->so_oe)),3);
    bufp->chgCData(oldp+234,((7U & vlSelf->so_pe)),3);
    bufp->chgCData(oldp+235,((7U & vlSelf->so_ps)),3);
    bufp->chgCData(oldp+236,((7U & vlSelf->so_sr)),3);
    bufp->chgCData(oldp+237,((7U & vlSelf->so_st)),3);
    bufp->chgSData(oldp+238,((0x1ffU & vlSelf->so_ds[0U])),9);
    bufp->chgIData(oldp+239,((0xffffffU & vlSelf->so_cfg[0U])),24);
    bufp->chgBit(oldp+240,((1U & (vlSelf->so_pad >> 1U))));
    bufp->chgBit(oldp+241,((1U & (vlSelf->so_a >> 1U))));
    bufp->chgBit(oldp+242,((1U & vlSelf->so_pad)));
    bufp->chgBit(oldp+243,((1U & vlSelf->so_a)));
    bufp->chgBit(oldp+244,((1U & (vlSelf->so_ie & vlSelf->so_pad))));
    bufp->chgBit(oldp+245,((1U & vlSelf->so_ie)));
    bufp->chgBit(oldp+246,((1U & vlSelf->so_oe)));
    bufp->chgBit(oldp+247,((1U & vlSelf->so_pe)));
    bufp->chgBit(oldp+248,((1U & vlSelf->so_ps)));
    bufp->chgBit(oldp+249,((1U & vlSelf->so_sr)));
    bufp->chgBit(oldp+250,((1U & vlSelf->so_st)));
    bufp->chgCData(oldp+251,((7U & vlSelf->so_ds[0U])),3);
    bufp->chgCData(oldp+252,((0xffU & vlSelf->so_cfg[0U])),8);
    bufp->chgBit(oldp+253,((1U & (vlSelf->so_pad >> 2U))));
    bufp->chgBit(oldp+254,((1U & (vlSelf->so_a >> 2U))));
    bufp->chgCData(oldp+255,((0xfU & (vlSelf->so_pad 
                                      >> 3U))),4);
    bufp->chgCData(oldp+256,((0xfU & (vlSelf->so_a 
                                      >> 3U))),4);
    bufp->chgCData(oldp+257,((0xfU & (vlSelf->so_ie 
                                      >> 3U))),4);
    bufp->chgCData(oldp+258,((0xfU & (vlSelf->so_oe 
                                      >> 3U))),4);
    bufp->chgCData(oldp+259,((0xfU & (vlSelf->so_pe 
                                      >> 3U))),4);
    bufp->chgCData(oldp+260,((0xfU & (vlSelf->so_ps 
                                      >> 3U))),4);
    bufp->chgCData(oldp+261,((0xfU & (vlSelf->so_sr 
                                      >> 3U))),4);
    bufp->chgCData(oldp+262,((0xfU & (vlSelf->so_st 
                                      >> 3U))),4);
    bufp->chgSData(oldp+263,((0xfffU & (vlSelf->so_ds[0U] 
                                        >> 9U))),12);
    bufp->chgIData(oldp+264,(((vlSelf->so_cfg[1U] << 8U) 
                              | (vlSelf->so_cfg[0U] 
                                 >> 0x18U))),32);
    bufp->chgBit(oldp+265,((1U & (vlSelf->so_pad >> 5U))));
    bufp->chgBit(oldp+266,((1U & (vlSelf->so_a >> 5U))));
    bufp->chgBit(oldp+267,((1U & (vlSelf->so_pad >> 6U))));
    bufp->chgBit(oldp+268,((1U & (vlSelf->so_a >> 6U))));
    bufp->chgBit(oldp+269,((1U & (vlSelf->so_pad >> 3U))));
    bufp->chgBit(oldp+270,((1U & (vlSelf->so_a >> 3U))));
    bufp->chgBit(oldp+271,((1U & ((vlSelf->so_ie & vlSelf->so_pad) 
                                  >> 3U))));
    bufp->chgBit(oldp+272,((1U & (vlSelf->so_ie >> 3U))));
    bufp->chgBit(oldp+273,((1U & (vlSelf->so_oe >> 3U))));
    bufp->chgBit(oldp+274,((1U & (vlSelf->so_pe >> 3U))));
    bufp->chgBit(oldp+275,((1U & (vlSelf->so_ps >> 3U))));
    bufp->chgBit(oldp+276,((1U & (vlSelf->so_sr >> 3U))));
    bufp->chgBit(oldp+277,((1U & (vlSelf->so_st >> 3U))));
    bufp->chgCData(oldp+278,((7U & (vlSelf->so_ds[0U] 
                                    >> 9U))),3);
    bufp->chgCData(oldp+279,((vlSelf->so_cfg[0U] >> 0x18U)),8);
    bufp->chgBit(oldp+280,((1U & (vlSelf->so_pad >> 4U))));
    bufp->chgBit(oldp+281,((1U & (vlSelf->so_a >> 4U))));
    bufp->chgBit(oldp+282,((1U & ((vlSelf->so_ie & vlSelf->so_pad) 
                                  >> 4U))));
    bufp->chgBit(oldp+283,((1U & (vlSelf->so_ie >> 4U))));
    bufp->chgBit(oldp+284,((1U & (vlSelf->so_oe >> 4U))));
    bufp->chgBit(oldp+285,((1U & (vlSelf->so_pe >> 4U))));
    bufp->chgBit(oldp+286,((1U & (vlSelf->so_ps >> 4U))));
    bufp->chgBit(oldp+287,((1U & (vlSelf->so_sr >> 4U))));
    bufp->chgBit(oldp+288,((1U & (vlSelf->so_st >> 4U))));
    bufp->chgCData(oldp+289,((7U & (vlSelf->so_ds[0U] 
                                    >> 0xcU))),3);
    bufp->chgCData(oldp+290,((0xffU & vlSelf->so_cfg[1U])),8);
    bufp->chgCData(oldp+291,((7U & (IData)(vlSelf->we_pad))),3);
    bufp->chgCData(oldp+292,((7U & (IData)(vlSelf->we_a))),3);
    bufp->chgCData(oldp+293,((7U & (IData)(vlSelf->we_ie))),3);
    bufp->chgCData(oldp+294,((7U & (IData)(vlSelf->we_oe))),3);
    bufp->chgCData(oldp+295,((7U & (IData)(vlSelf->we_pe))),3);
    bufp->chgCData(oldp+296,((7U & (IData)(vlSelf->we_ps))),3);
    bufp->chgCData(oldp+297,((7U & (IData)(vlSelf->we_sr))),3);
    bufp->chgCData(oldp+298,((7U & (IData)(vlSelf->we_st))),3);
    bufp->chgSData(oldp+299,((0x1ffU & vlSelf->we_ds[0U])),9);
    bufp->chgIData(oldp+300,((0xffffffU & vlSelf->we_cfg[0U])),24);
    bufp->chgBit(oldp+301,((1U & (IData)((vlSelf->we_pad 
                                          >> 1U)))));
    bufp->chgBit(oldp+302,((1U & (IData)((vlSelf->we_a 
                                          >> 1U)))));
    bufp->chgBit(oldp+303,((1U & (IData)(vlSelf->we_pad))));
    bufp->chgBit(oldp+304,((1U & (IData)(vlSelf->we_a))));
    bufp->chgBit(oldp+305,((1U & ((IData)(vlSelf->we_ie) 
                                  & (IData)(vlSelf->we_pad)))));
    bufp->chgBit(oldp+306,((1U & (IData)(vlSelf->we_ie))));
    bufp->chgBit(oldp+307,((1U & (IData)(vlSelf->we_oe))));
    bufp->chgBit(oldp+308,((1U & (IData)(vlSelf->we_pe))));
    bufp->chgBit(oldp+309,((1U & (IData)(vlSelf->we_ps))));
    bufp->chgBit(oldp+310,((1U & (IData)(vlSelf->we_sr))));
    bufp->chgBit(oldp+311,((1U & (IData)(vlSelf->we_st))));
    bufp->chgCData(oldp+312,((7U & vlSelf->we_ds[0U])),3);
    bufp->chgCData(oldp+313,((0xffU & vlSelf->we_cfg[0U])),8);
    bufp->chgBit(oldp+314,((1U & (IData)((vlSelf->we_pad 
                                          >> 2U)))));
    bufp->chgBit(oldp+315,((1U & (IData)((vlSelf->we_a 
                                          >> 2U)))));
    bufp->chgCData(oldp+316,((0xfU & (IData)((vlSelf->we_pad 
                                              >> 3U)))),4);
    bufp->chgCData(oldp+317,((0xfU & (IData)((vlSelf->we_a 
                                              >> 3U)))),4);
    bufp->chgCData(oldp+318,((0xfU & (IData)((vlSelf->we_ie 
                                              >> 3U)))),4);
    bufp->chgCData(oldp+319,((0xfU & (IData)((vlSelf->we_oe 
                                              >> 3U)))),4);
    bufp->chgCData(oldp+320,((0xfU & (IData)((vlSelf->we_pe 
                                              >> 3U)))),4);
    bufp->chgCData(oldp+321,((0xfU & (IData)((vlSelf->we_ps 
                                              >> 3U)))),4);
    bufp->chgCData(oldp+322,((0xfU & (IData)((vlSelf->we_sr 
                                              >> 3U)))),4);
    bufp->chgCData(oldp+323,((0xfU & (IData)((vlSelf->we_st 
                                              >> 3U)))),4);
    bufp->chgSData(oldp+324,((0xfffU & (vlSelf->we_ds[0U] 
                                        >> 9U))),12);
    bufp->chgIData(oldp+325,(((vlSelf->we_cfg[1U] << 8U) 
                              | (vlSelf->we_cfg[0U] 
                                 >> 0x18U))),32);
    bufp->chgBit(oldp+326,((1U & (IData)((vlSelf->we_pad 
                                          >> 5U)))));
    bufp->chgBit(oldp+327,((1U & (IData)((vlSelf->we_a 
                                          >> 5U)))));
    bufp->chgBit(oldp+328,((1U & (IData)((vlSelf->we_pad 
                                          >> 6U)))));
    bufp->chgBit(oldp+329,((1U & (IData)((vlSelf->we_a 
                                          >> 6U)))));
    bufp->chgBit(oldp+330,((1U & (IData)((vlSelf->we_pad 
                                          >> 3U)))));
    bufp->chgBit(oldp+331,((1U & (IData)((vlSelf->we_a 
                                          >> 3U)))));
    bufp->chgBit(oldp+332,((1U & ((IData)((vlSelf->we_ie 
                                           >> 3U)) 
                                  & (IData)((vlSelf->we_pad 
                                             >> 3U))))));
    bufp->chgBit(oldp+333,((1U & (IData)((vlSelf->we_ie 
                                          >> 3U)))));
    bufp->chgBit(oldp+334,((1U & (IData)((vlSelf->we_oe 
                                          >> 3U)))));
    bufp->chgBit(oldp+335,((1U & (IData)((vlSelf->we_pe 
                                          >> 3U)))));
    bufp->chgBit(oldp+336,((1U & (IData)((vlSelf->we_ps 
                                          >> 3U)))));
    bufp->chgBit(oldp+337,((1U & (IData)((vlSelf->we_sr 
                                          >> 3U)))));
    bufp->chgBit(oldp+338,((1U & (IData)((vlSelf->we_st 
                                          >> 3U)))));
    bufp->chgCData(oldp+339,((7U & (vlSelf->we_ds[0U] 
                                    >> 9U))),3);
    bufp->chgCData(oldp+340,((vlSelf->we_cfg[0U] >> 0x18U)),8);
    bufp->chgBit(oldp+341,((1U & (IData)((vlSelf->we_pad 
                                          >> 4U)))));
    bufp->chgBit(oldp+342,((1U & (IData)((vlSelf->we_a 
                                          >> 4U)))));
    bufp->chgBit(oldp+343,((1U & ((IData)((vlSelf->we_ie 
                                           >> 4U)) 
                                  & (IData)((vlSelf->we_pad 
                                             >> 4U))))));
    bufp->chgBit(oldp+344,((1U & (IData)((vlSelf->we_ie 
                                          >> 4U)))));
    bufp->chgBit(oldp+345,((1U & (IData)((vlSelf->we_oe 
                                          >> 4U)))));
    bufp->chgBit(oldp+346,((1U & (IData)((vlSelf->we_pe 
                                          >> 4U)))));
    bufp->chgBit(oldp+347,((1U & (IData)((vlSelf->we_ps 
                                          >> 4U)))));
    bufp->chgBit(oldp+348,((1U & (IData)((vlSelf->we_sr 
                                          >> 4U)))));
    bufp->chgBit(oldp+349,((1U & (IData)((vlSelf->we_st 
                                          >> 4U)))));
    bufp->chgCData(oldp+350,((7U & (vlSelf->we_ds[0U] 
                                    >> 0xcU))),3);
    bufp->chgCData(oldp+351,((0xffU & vlSelf->we_cfg[1U])),8);
}

void Vla_iopadring___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vla_iopadring___024root__trace_cleanup\n"); );
    // Init
    Vla_iopadring___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vla_iopadring___024root*>(voidSelf);
    Vla_iopadring__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
}
