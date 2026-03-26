"""Cocotb driver for single-port RAM-like interfaces.

Provides async write/read methods that drive ce, we, wmask, addr, din signals
and sample dout, with optional post-access signal randomization to stress
hold-time and bus-contention behavior.
"""

import random
from cocotb.triggers import RisingEdge, FallingEdge


class RamDriver:
    def __init__(
        self,
        clk,
        ce,
        we,
        wmask,
        addr,
        din,
        dout,
        ctrl
    ):
        """Initialize driver with DUT signal handles.

        Args:
            clk: Clock signal.
            ce: Chip enable.
            we: Write enable.
            wmask: Bit-level write mask (1 = write, 0 = preserve).
            addr: Address bus.
            din: Data input bus.
            dout: Data output bus.
            ctrl: Control/configuration signal.
        """
        self.clk = clk
        self.ce = ce
        self.we = we
        self.wmask = wmask
        self.addr = addr
        self.din = din
        self.dout = dout
        self.ctrl = ctrl

        self.addr_width = len(addr)
        self.data_width = len(din)

    def init(self, ctrl_value=0):
        """Drive all signals to idle state."""
        self.ce.value = 0
        self.we.value = 0
        self.wmask.value = 0
        self.addr.value = 0
        self.din.value = 0
        self.ctrl.value = ctrl_value

    async def write(
        self,
        addr,
        data,
        wmask=None,
        randomize_after_write=False
    ):
        """Perform a single write transaction.

        Asserts ce and we, drives addr/din/wmask on the current cycle,
        then de-asserts on the next falling edge. When *randomize_after_write*
        is True, random values are driven after the rising edge to stress
        hold-time behavior.
        """
        if wmask is None:
            wmask = (1 << self.data_width) - 1

        self.addr.value = addr
        self.din.value = data
        self.wmask.value = wmask

        self.we.value = 1
        self.ce.value = 1

        if randomize_after_write:
            await RisingEdge(self.clk)
            self.addr.value = random.randint(0, (1 << self.addr_width) - 1)
            self.din.value = random.randint(0, (1 << self.data_width) - 1)
            self.wmask.value = random.randint(0, (1 << self.data_width) - 1)

        await FallingEdge(self.clk)
        self.we.value = 0
        self.ce.value = 0

    async def read(
        self,
        addr,
        randomize_after_read=False,
        resolve="random"
    ):
        """Perform a single read transaction and return the unsigned result.

        Asserts ce (with we=0), drives addr, waits one cycle, then returns
        dout resolved to an unsigned integer. The *resolve* parameter controls
        how X/Z bits are resolved (e.g. "random", "zeros").
        """
        self.addr.value = addr
        self.we.value = 0
        self.ce.value = 1

        if randomize_after_read:
            await RisingEdge(self.clk)
            self.addr.value = random.randint(0, (1 << self.addr_width) - 1)
            self.din.value = random.randint(0, (1 << self.data_width) - 1)
            self.wmask.value = random.randint(0, (1 << self.data_width) - 1)

        await FallingEdge(self.clk)
        self.ce.value = 0

        return self.dout.value.resolve(resolve).to_unsigned()
