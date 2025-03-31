import logging

import cocotb
from cocotb.triggers import RisingEdge
from cocotb_bus.bus import Bus
from cocotb.queue import Queue
from cocotb.binary import BinaryValue


class LaAsyncFifoWrBus(Bus):

    _signals = ["wr_din", "wr_en", "wr_full"]
    _optional_signals = ["wr_almost_full", "wr_chaosmode"]

    def __init__(self, entity=None, prefix=None, **kwargs):
        super().__init__(
            entity,
            prefix,
            self._signals,
            optional_signals=self._optional_signals,
            **kwargs
        )

    @classmethod
    def from_entity(cls, entity, **kwargs):
        return cls(entity, **kwargs)

    @classmethod
    def from_prefix(cls, entity, prefix, **kwargs):
        return cls(entity, prefix, **kwargs)


class LaAsyncFifoRdBus(Bus):

    _signals = ["rd_dout", "rd_en", "rd_empty"]
    _optional_signals = []

    def __init__(self, entity=None, prefix=None, **kwargs):
        super().__init__(
            entity,
            prefix,
            self._signals,
            optional_signals=self._optional_signals,
            **kwargs
        )

    @classmethod
    def from_entity(cls, entity, **kwargs):
        return cls(entity, **kwargs)

    @classmethod
    def from_prefix(cls, entity, prefix, **kwargs):
        return cls(entity, prefix, **kwargs)


class LaAsyncFifoSource:

    def __init__(self, bus: LaAsyncFifoWrBus, clock, reset=None):
        self.bus = bus
        self.clock = clock
        self.reset = reset
        self.log = logging.getLogger(f"cocotb.{bus._entity._name}.{bus._name}")

        self.queue = Queue()
        self.width = len(self.bus.wr_din)

        self._run_cr = cocotb.start_soon(self._run())

        self.bus.wr_chaosmode.value = 0
        self.bus.wr_en.value = 0

        self.wr_en_generator = None

    def set_wr_en_generator(self, generator):
        self.wr_en_generator = generator

    async def send(self, data):
        await self.queue.put(data)

    async def wait_until_idle(self):
        while not self.queue.empty() or self.bus.wr_en.value == 1:
            await RisingEdge(self.clock)

    async def _run(self):
        clock_edge_event = RisingEdge(self.clock)

        bus_val = None

        while True:
            await clock_edge_event

            fifo_full = self.bus.wr_full.value
            wr_en = self.bus.wr_en.value

            if bus_val is None:
                bus_val = await self.queue.get()
            elif wr_en and not fifo_full:
                bus_val = None if self.queue.empty() else self.queue.get_nowait()

            if bus_val is None:
                self.bus.wr_en.value = 0
            else:
                self.bus.wr_en.value = next(self.wr_en_generator) if self.wr_en_generator else 1

            self.bus.wr_din.value = bus_val if bus_val else 0


class LaAsyncFifoSink:

    def __init__(self, bus: LaAsyncFifoRdBus, clock, reset=None):
        self.bus = bus
        self.clock = clock
        self.reset = reset
        self.log = logging.getLogger(f"cocotb.{bus._entity._name}.{bus._name}")

        self.queue = Queue()
        self.width = len(self.bus.rd_dout)

        self._run_cr = cocotb.start_soon(self._run())

        self.bus.rd_en.value = 0

        self.rd_en_generator = None
        self._pause = False

    def set_rd_en_generator(self, generator):
        self.rd_en_generator = generator

    def pause(self):
        self.bus.rd_en.value = 0
        self._pause = True

    def resume(self):
        self._pause = False

    async def read(self) -> BinaryValue:
        return await self.queue.get()

    async def _run(self):

        clock_edge_event = RisingEdge(self.clock)

        while True:
            await clock_edge_event

            fifo_empty = self.bus.rd_empty.value
            if self.rd_en_generator:
                self.bus.rd_en.value = next(self.rd_en_generator)
            elif not self._pause:
                self.bus.rd_en.value = 1
            else:
                self.bus.rd_en.value = 0

            if self.bus.rd_en.value and not fifo_empty:
                self.queue.put_nowait(self.bus.rd_dout.value)
