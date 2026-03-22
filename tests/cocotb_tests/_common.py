"""
Shared cocotb test configuration and utilities.
"""

try:
    import cocotb
    _has_cocotb = True
except ModuleNotFoundError:
    _has_cocotb = False


if _has_cocotb:
    async def reset_dut(dut, active_level=False):
        """Perform an asynchronous reset on DUT"""
        dut.rst.value = active_level
        await cocotb.triggers.Timer(100, "ns")
        dut.rst.value = not active_level
        await cocotb.triggers.Timer(1, unit="step")
