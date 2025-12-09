from typing import Any

from cocotb.triggers import RisingEdge
from cocotb.handle import SimHandleBase

from cocotb_bus.drivers import ValidatedBusDriver


class LaAsyncFifoWrDriver(ValidatedBusDriver):
    """Driver for write side of lambdalib async fifo"""

    _signals = [
        "wr_din",
        "wr_en",
        "wr_full"
    ]
    _optional_signals = [
        "wr_almost_full",
        "wr_chaosmode"
    ]

    def __init__(
        self,
        entity: SimHandleBase,
        name: str,
        clock: SimHandleBase,
        *,
        config={},
        **kwargs: Any
    ):
        ValidatedBusDriver.__init__(self, entity, name, clock, **kwargs)

        self.clock = clock
        self.bus.wr_en.value = 0

    async def _driver_send(
        self,
        transaction: int,
        sync: bool = True
    ) -> None:
        """Implementation for BusDriver.
        Args:
            transaction: The transaction to send.
            sync: Synchronize the transfer by waiting for a rising edge.
        """

        clk_re = RisingEdge(self.clock)

        if sync:
            await clk_re

        # Insert a gap where valid is low
        if not self.on:
            self.bus.wr_en.value = 0
            for _ in range(self.off):
                await clk_re

            # Grab the next set of on/off values
            self._next_valids()

        # Consume a valid cycle
        if self.on is not True and self.on:
            self.on -= 1

        def ready() -> bool:
            return not bool(self.bus.wr_full.value)

        while True:
            self.bus.wr_en.value = 1
            self.bus.wr_din.value = transaction
            await clk_re
            if ready():
                break

        self.bus.wr_en.value = 0
