import cocotb
from cocotb.triggers import RisingEdge


class RamMonitor:
    def __init__(self, dut):
        self.clk = dut.clk
        self.ce = dut.ce
        self.we = dut.we
        self.wmask = dut.wmask
        self.addr = dut.addr
        self.din = dut.din

        self.addr_width = len(dut.addr)
        self.data_width = len(dut.din)

        self.monitor_task = None

        self.mem = {}

        self.log = dut._log

    def start(self):
        if self.monitor_task is None:
            self.monitor_task = cocotb.start_soon(self._monitor())

    def is_write(self) -> bool:
        return bool(self.ce.value) and bool(self.we.value)

    async def _monitor(self):
        while True:
            await RisingEdge(self.clk)
            if self.is_write():
                addr = self.addr.value.to_unsigned()
                wmask = self.wmask.value.to_unsigned()
                data = self.din.value.to_unsigned()
                if addr not in self.mem:
                    self.mem[addr] = 0
                self.mem[addr] = (self.mem[addr] & ~wmask) | (data & wmask)
                self.log.debug(
                    f"Monitor captured write: addr={hex(addr)}, ",
                    f"data={hex(data)}, wmask={hex(wmask)}, mem[{hex(addr)}]={hex(self.mem[addr])}"
                )
