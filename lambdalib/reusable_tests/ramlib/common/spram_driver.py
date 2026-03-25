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
