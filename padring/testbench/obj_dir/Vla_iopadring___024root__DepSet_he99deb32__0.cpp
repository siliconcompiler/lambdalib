// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vla_iopadring.h for the primary calling header

#include "verilated.h"

#include "Vla_iopadring___024root.h"

VL_INLINE_OPT void Vla_iopadring___024root___combo__TOP__0(Vla_iopadring___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vla_iopadring__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vla_iopadring___024root___combo__TOP__0\n"); );
    // Init
    CData/*7:0*/ la_iopadring__DOT__pad__en0;
    SData/*15:0*/ la_iopadring__DOT__pad__en6;
    IData/*31:0*/ la_iopadring__DOT__pad__en12;
    QData/*63:0*/ la_iopadring__DOT__pad__en18;
    CData/*3:0*/ la_iopadring__DOT__inorth__DOT__pad__en12;
    CData/*0:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2;
    CData/*0:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2;
    CData/*0:0*/ la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2;
    CData/*3:0*/ la_iopadring__DOT__ieast__DOT__pad__en12;
    CData/*0:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1;
    CData/*0:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1;
    CData/*0:0*/ la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1;
    CData/*3:0*/ la_iopadring__DOT__isouth__DOT__pad__en12;
    CData/*0:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1;
    CData/*0:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1;
    CData/*0:0*/ la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1;
    CData/*3:0*/ la_iopadring__DOT__iwest__DOT__pad__en12;
    CData/*0:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2;
    CData/*0:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2;
    CData/*0:0*/ la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2;
    // Body
    la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2 
        = (1U & ((IData)(vlSelf->no_oe) | (IData)(vlSelf->no_pe)));
    la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1 
        = (1U & ((IData)(vlSelf->ea_oe) | (IData)(vlSelf->ea_pe)));
    la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1 
        = (1U & (vlSelf->so_oe | vlSelf->so_pe));
    la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2 
        = (1U & (vlSelf->we_oe | vlSelf->we_pe));
    la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2 
        = (1U & (((IData)(vlSelf->no_oe) | (IData)(vlSelf->no_pe)) 
                 >> 3U));
    la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2 
        = (1U & (((IData)(vlSelf->no_oe) | (IData)(vlSelf->no_pe)) 
                 >> 4U));
    la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1 
        = (1U & (((IData)(vlSelf->ea_oe) | (IData)(vlSelf->ea_pe)) 
                 >> 3U));
    la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1 
        = (1U & (((IData)(vlSelf->ea_oe) | (IData)(vlSelf->ea_pe)) 
                 >> 4U));
    la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1 
        = (1U & ((vlSelf->so_oe | vlSelf->so_pe) >> 3U));
    la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1 
        = (1U & ((vlSelf->so_oe | vlSelf->so_pe) >> 4U));
    la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2 
        = (1U & ((vlSelf->we_oe | vlSelf->we_pe) >> 3U));
    la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2 
        = (1U & ((vlSelf->we_oe | vlSelf->we_pe) >> 4U));
    vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48 
        = ((6U & (IData)(vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48)) 
           | (((1U & (IData)(vlSelf->no_oe)) ? (IData)(vlSelf->no_a)
                : ((IData)(vlSelf->no_pe) & (IData)(vlSelf->no_ps))) 
              & (IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)));
    vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48 
        = ((6U & (IData)(vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48)) 
           | (((1U & (IData)(vlSelf->ea_oe)) ? (IData)(vlSelf->ea_a)
                : ((IData)(vlSelf->ea_pe) & (IData)(vlSelf->ea_ps))) 
              & (IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)));
    vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48 
        = ((6U & (IData)(vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48)) 
           | (((1U & vlSelf->so_oe) ? vlSelf->so_a : 
               (vlSelf->so_pe & vlSelf->so_ps)) & (IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)));
    vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48 
        = ((6U & (IData)(vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48)) 
           | (((1U & (IData)(vlSelf->we_oe)) ? (IData)(vlSelf->we_a)
                : ((IData)(vlSelf->we_pe) & (IData)(vlSelf->we_ps))) 
              & (IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)));
    vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79 
        = ((0xeU & (IData)(vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79)) 
           | (((8U & (IData)(vlSelf->no_oe)) ? ((IData)(vlSelf->no_a) 
                                                >> 3U)
                : (((IData)(vlSelf->no_pe) & (IData)(vlSelf->no_ps)) 
                   >> 3U)) & (IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)));
    vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80 
        = ((0xdU & (IData)(vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80)) 
           | ((((0x10U & (IData)(vlSelf->no_oe)) ? 
                ((IData)(vlSelf->no_a) >> 4U) : (((IData)(vlSelf->no_pe) 
                                                  & (IData)(vlSelf->no_ps)) 
                                                 >> 4U)) 
               & (IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2)) 
              << 1U));
    la_iopadring__DOT__inorth__DOT__pad__en12 = (0xfU 
                                                 & ((IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2) 
                                                    | ((IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2) 
                                                       << 1U)));
    vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79 
        = ((0xeU & (IData)(vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79)) 
           | (((8U & (IData)(vlSelf->ea_oe)) ? ((IData)(vlSelf->ea_a) 
                                                >> 3U)
                : (((IData)(vlSelf->ea_pe) & (IData)(vlSelf->ea_ps)) 
                   >> 3U)) & (IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)));
    vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80 
        = ((0xdU & (IData)(vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80)) 
           | ((((0x10U & (IData)(vlSelf->ea_oe)) ? 
                ((IData)(vlSelf->ea_a) >> 4U) : (((IData)(vlSelf->ea_pe) 
                                                  & (IData)(vlSelf->ea_ps)) 
                                                 >> 4U)) 
               & (IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1)) 
              << 1U));
    la_iopadring__DOT__ieast__DOT__pad__en12 = (0xfU 
                                                & ((IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1) 
                                                   | ((IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1) 
                                                      << 1U)));
    vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79 
        = ((0xeU & (IData)(vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79)) 
           | (((8U & vlSelf->so_oe) ? (vlSelf->so_a 
                                       >> 3U) : ((vlSelf->so_pe 
                                                  & vlSelf->so_ps) 
                                                 >> 3U)) 
              & (IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)));
    vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80 
        = ((0xdU & (IData)(vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80)) 
           | ((((0x10U & vlSelf->so_oe) ? (vlSelf->so_a 
                                           >> 4U) : 
                ((vlSelf->so_pe & vlSelf->so_ps) >> 4U)) 
               & (IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1)) 
              << 1U));
    la_iopadring__DOT__isouth__DOT__pad__en12 = (0xfU 
                                                 & ((IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1) 
                                                    | ((IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1) 
                                                       << 1U)));
    vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79 
        = ((0xeU & (IData)(vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79)) 
           | (((1U & (IData)((vlSelf->we_oe >> 3U)))
                ? (IData)((vlSelf->we_a >> 3U)) : ((IData)(
                                                           (vlSelf->we_pe 
                                                            >> 3U)) 
                                                   & (IData)(
                                                             (vlSelf->we_ps 
                                                              >> 3U)))) 
              & (IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)));
    vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80 
        = ((0xdU & (IData)(vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80)) 
           | ((((1U & (IData)((vlSelf->we_oe >> 4U)))
                 ? (IData)((vlSelf->we_a >> 4U)) : 
                ((IData)((vlSelf->we_pe >> 4U)) & (IData)(
                                                          (vlSelf->we_ps 
                                                           >> 4U)))) 
               & (IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2)) 
              << 1U));
    la_iopadring__DOT__iwest__DOT__pad__en12 = (0xfU 
                                                & ((IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2) 
                                                   | ((IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2) 
                                                      << 1U)));
    vlSelf->la_iopadring__DOT__inorth__DOT__pad__out__out72 
        = ((0xf8U & (IData)(vlSelf->la_iopadring__DOT__inorth__DOT__pad__out__out72)) 
           | ((IData)(vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48) 
              & (IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)));
    vlSelf->la_iopadring__DOT__ieast__DOT__pad__out__out44 
        = ((0xfff8U & (IData)(vlSelf->la_iopadring__DOT__ieast__DOT__pad__out__out44)) 
           | ((IData)(vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48) 
              & (IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)));
    vlSelf->la_iopadring__DOT__isouth__DOT__pad__out__out44 
        = ((0xfffffff8U & vlSelf->la_iopadring__DOT__isouth__DOT__pad__out__out44) 
           | ((IData)(vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48) 
              & (IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)));
    vlSelf->la_iopadring__DOT__iwest__DOT__pad__out__out68 
        = ((0xfffffffffffffff8ULL & vlSelf->la_iopadring__DOT__iwest__DOT__pad__out__out68) 
           | (IData)((IData)(((IData)(vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__pad__out__out48) 
                              & (IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)))));
    vlSelf->la_iopadring__DOT__inorth__DOT__pad__out__out73 
        = ((0x87U & (IData)(vlSelf->la_iopadring__DOT__inorth__DOT__pad__out__out73)) 
           | ((((IData)(vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79) 
                & (IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)) 
               << 3U) | (((IData)(vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80) 
                          << 3U) & ((IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2) 
                                    << 4U))));
    la_iopadring__DOT__pad__en0 = (0xffU & ((IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2) 
                                            | ((IData)(la_iopadring__DOT__inorth__DOT__pad__en12) 
                                               << 3U)));
    vlSelf->la_iopadring__DOT__ieast__DOT__pad__out__out45 
        = ((0xff87U & (IData)(vlSelf->la_iopadring__DOT__ieast__DOT__pad__out__out45)) 
           | ((((IData)(vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79) 
                & (IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)) 
               << 3U) | (((IData)(vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80) 
                          << 3U) & ((IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1) 
                                    << 4U))));
    la_iopadring__DOT__pad__en6 = (0xffffU & ((IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1) 
                                              | ((IData)(la_iopadring__DOT__ieast__DOT__pad__en12) 
                                                 << 3U)));
    vlSelf->la_iopadring__DOT__isouth__DOT__pad__out__out45 
        = ((0xffffff87U & vlSelf->la_iopadring__DOT__isouth__DOT__pad__out__out45) 
           | ((((IData)(vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79) 
                & (IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)) 
               << 3U) | (((IData)(vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80) 
                          << 3U) & ((IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en1) 
                                    << 4U))));
    la_iopadring__DOT__pad__en12 = ((IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1) 
                                    | ((IData)(la_iopadring__DOT__isouth__DOT__pad__en12) 
                                       << 3U));
    vlSelf->la_iopadring__DOT__iwest__DOT__pad__out__out69 
        = ((0xffffffffffffff87ULL & vlSelf->la_iopadring__DOT__iwest__DOT__pad__out__out69) 
           | ((QData)((IData)((((IData)(vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out79) 
                                & (IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)) 
                               | ((IData)(vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__pad__out__out80) 
                                  & ((IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT__ila_iobidir__BRA__1__KET____DOT__i0__DOT__pad__out__en2) 
                                     << 1U))))) << 3U));
    la_iopadring__DOT__pad__en18 = ((QData)((IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)) 
                                    | ((QData)((IData)(la_iopadring__DOT__iwest__DOT__pad__en12)) 
                                       << 3U));
    vlSelf->no_pad = (((((IData)(vlSelf->la_iopadring__DOT__inorth__DOT__pad__out__out72) 
                         & (IData)(la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2)) 
                        | ((IData)(vlSelf->la_iopadring__DOT__inorth__DOT__pad__out__out73) 
                           & ((IData)(la_iopadring__DOT__inorth__DOT__pad__en12) 
                              << 3U))) & (IData)(la_iopadring__DOT__pad__en0)) 
                      & (IData)(la_iopadring__DOT__pad__en0));
    vlSelf->ea_pad = (((((IData)(vlSelf->la_iopadring__DOT__ieast__DOT__pad__out__out44) 
                         & (IData)(la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)) 
                        | ((IData)(vlSelf->la_iopadring__DOT__ieast__DOT__pad__out__out45) 
                           & ((IData)(la_iopadring__DOT__ieast__DOT__pad__en12) 
                              << 3U))) & (IData)(la_iopadring__DOT__pad__en6)) 
                      & (IData)(la_iopadring__DOT__pad__en6));
    vlSelf->so_pad = ((((vlSelf->la_iopadring__DOT__isouth__DOT__pad__out__out44 
                         & (IData)(la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en1)) 
                        | (vlSelf->la_iopadring__DOT__isouth__DOT__pad__out__out45 
                           & ((IData)(la_iopadring__DOT__isouth__DOT__pad__en12) 
                              << 3U))) & la_iopadring__DOT__pad__en12) 
                      & la_iopadring__DOT__pad__en12);
    vlSelf->we_pad = ((((vlSelf->la_iopadring__DOT__iwest__DOT__pad__out__out68 
                         & (QData)((IData)(la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT__ila_iobidir__BRA__0__KET____DOT__i0__DOT__pad__out__en2))) 
                        | (vlSelf->la_iopadring__DOT__iwest__DOT__pad__out__out69 
                           & ((QData)((IData)(la_iopadring__DOT__iwest__DOT__pad__en12)) 
                              << 3U))) & la_iopadring__DOT__pad__en18) 
                      & la_iopadring__DOT__pad__en18);
    vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z 
        = ((4U & (IData)(vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z)) 
           | (((IData)(vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__1__KET____DOT__i0__z) 
               << 1U) | (1U & ((IData)(vlSelf->no_ie) 
                               & (IData)(vlSelf->no_pad)))));
    vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z 
        = ((0xeU & (IData)(vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z)) 
           | (1U & (((IData)(vlSelf->no_ie) & (IData)(vlSelf->no_pad)) 
                    >> 3U)));
    vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z 
        = ((9U & (IData)(vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z)) 
           | (((IData)(vlSelf->la_iopadring__DOT__inorth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__2__KET____DOT__i0__z) 
               << 2U) | (2U & (((IData)(vlSelf->no_ie) 
                                & (IData)(vlSelf->no_pad)) 
                               >> 3U))));
    vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z 
        = ((4U & (IData)(vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z)) 
           | (((IData)(vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__1__KET____DOT__i0__z) 
               << 1U) | (1U & ((IData)(vlSelf->ea_ie) 
                               & (IData)(vlSelf->ea_pad)))));
    vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z 
        = ((0xeU & (IData)(vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z)) 
           | (1U & (((IData)(vlSelf->ea_ie) & (IData)(vlSelf->ea_pad)) 
                    >> 3U)));
    vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z 
        = ((9U & (IData)(vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z)) 
           | (((IData)(vlSelf->la_iopadring__DOT__ieast__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__2__KET____DOT__i0__z) 
               << 2U) | (2U & (((IData)(vlSelf->ea_ie) 
                                & (IData)(vlSelf->ea_pad)) 
                               >> 3U))));
    vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z 
        = ((4U & (IData)(vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z)) 
           | (((IData)(vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__1__KET____DOT__i0__z) 
               << 1U) | (1U & (vlSelf->so_ie & vlSelf->so_pad))));
    vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z 
        = ((0xeU & (IData)(vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z)) 
           | (1U & ((vlSelf->so_ie & vlSelf->so_pad) 
                    >> 3U)));
    vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z 
        = ((9U & (IData)(vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z)) 
           | (((IData)(vlSelf->la_iopadring__DOT__isouth__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__2__KET____DOT__i0__z) 
               << 2U) | (2U & ((vlSelf->so_ie & vlSelf->so_pad) 
                               >> 3U))));
    vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z 
        = ((4U & (IData)(vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z)) 
           | (((IData)(vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__0__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__1__KET____DOT__i0__z) 
               << 1U) | (1U & ((IData)(vlSelf->we_ie) 
                               & (IData)(vlSelf->we_pad)))));
    vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z 
        = ((0xeU & (IData)(vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z)) 
           | (1U & ((IData)((vlSelf->we_ie >> 3U)) 
                    & (IData)((vlSelf->we_pad >> 3U)))));
    vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z 
        = ((9U & (IData)(vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z)) 
           | (((IData)(vlSelf->la_iopadring__DOT__iwest__DOT__ila_iosection__BRA__1__KET____DOT__i0__DOT____Vcellout__ila_ioanalog__BRA__2__KET____DOT__i0__z) 
               << 2U) | (2U & (((IData)((vlSelf->we_ie 
                                         >> 4U)) & (IData)(
                                                           (vlSelf->we_pad 
                                                            >> 4U))) 
                               << 1U))));
    vlSelf->no_z = ((0x80U & (IData)(vlSelf->no_z)) 
                    | (((IData)(vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z) 
                        << 3U) | (IData)(vlSelf->la_iopadring__DOT__inorth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z)));
    vlSelf->ea_z = ((0xff80U & (IData)(vlSelf->ea_z)) 
                    | (((IData)(vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z) 
                        << 3U) | (IData)(vlSelf->la_iopadring__DOT__ieast__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z)));
    vlSelf->so_z = ((0xffffff80U & vlSelf->so_z) | 
                    (((IData)(vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z) 
                      << 3U) | (IData)(vlSelf->la_iopadring__DOT__isouth__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z)));
    vlSelf->we_z = ((0xffffffffffffff80ULL & vlSelf->we_z) 
                    | (IData)((IData)((((IData)(vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__1__KET____DOT__i0__z) 
                                        << 3U) | (IData)(vlSelf->la_iopadring__DOT__iwest__DOT____Vcellout__ila_iosection__BRA__0__KET____DOT__i0__z)))));
}

void Vla_iopadring___024root___eval(Vla_iopadring___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vla_iopadring__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vla_iopadring___024root___eval\n"); );
    // Body
    Vla_iopadring___024root___combo__TOP__0(vlSelf);
    vlSelf->__Vm_traceActivity[1U] = 1U;
}

#ifdef VL_DEBUG
void Vla_iopadring___024root___eval_debug_assertions(Vla_iopadring___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vla_iopadring__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vla_iopadring___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->vss & 0xfeU))) {
        Verilated::overWidthError("vss");}
    if (VL_UNLIKELY((vlSelf->no_ds & 0xff000000U))) {
        Verilated::overWidthError("no_ds");}
    if (VL_UNLIKELY((vlSelf->no_vdd & 0xfcU))) {
        Verilated::overWidthError("no_vdd");}
    if (VL_UNLIKELY((vlSelf->no_vddio & 0xfcU))) {
        Verilated::overWidthError("no_vddio");}
    if (VL_UNLIKELY((vlSelf->no_vssio & 0xfcU))) {
        Verilated::overWidthError("no_vssio");}
    if (VL_UNLIKELY((vlSelf->ea_ds & 0ULL))) {
        Verilated::overWidthError("ea_ds");}
    if (VL_UNLIKELY((vlSelf->ea_vdd & 0xfcU))) {
        Verilated::overWidthError("ea_vdd");}
    if (VL_UNLIKELY((vlSelf->ea_vddio & 0xfcU))) {
        Verilated::overWidthError("ea_vddio");}
    if (VL_UNLIKELY((vlSelf->ea_vssio & 0xfcU))) {
        Verilated::overWidthError("ea_vssio");}
    if (VL_UNLIKELY((vlSelf->so_vdd & 0xfcU))) {
        Verilated::overWidthError("so_vdd");}
    if (VL_UNLIKELY((vlSelf->so_vddio & 0xfcU))) {
        Verilated::overWidthError("so_vddio");}
    if (VL_UNLIKELY((vlSelf->so_vssio & 0xfcU))) {
        Verilated::overWidthError("so_vssio");}
    if (VL_UNLIKELY((vlSelf->we_vdd & 0xfcU))) {
        Verilated::overWidthError("we_vdd");}
    if (VL_UNLIKELY((vlSelf->we_vddio & 0xfcU))) {
        Verilated::overWidthError("we_vddio");}
    if (VL_UNLIKELY((vlSelf->we_vssio & 0xfcU))) {
        Verilated::overWidthError("we_vssio");}
}
#endif  // VL_DEBUG
