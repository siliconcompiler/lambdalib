from cocotb.triggers import RisingEdge
from cocotb_bus.monitors import BusMonitor


class LaAsyncFifoRdMonitor(BusMonitor):
    """Monitor for read side of lambdalib async fifo"""

    _signals = [
        "rd_dout",
        "rd_en",
        "rd_empty"
    ]
    _optional_signals = []

    def __init__(self, entity, name, clock, **kwargs):
        BusMonitor.__init__(self, entity, name, clock, **kwargs)

    async def _monitor_recv(self):
        clk_re = RisingEdge(self.clock)

        def valid_handshake():
            return bool(self.bus.rd_en.value) and not bool(self.bus.rd_empty.value)

        while True:
            await clk_re
            if valid_handshake():
                self._recv(self.bus.rd_dout.value.to_unsigned())
