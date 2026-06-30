import itertools
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import (
        Timer,
        FallingEdge,
        RisingEdge
        )


async def toggle_reset(rstn_pin):
    rstn_pin.value = 1
    await Timer(2, "ns")
    rstn_pin.value = 0
    await Timer(2, "ns")
    rstn_pin.value = 1


async def pre_test(dut):
    dut.i_clk.value = 0
    dut.i_start.value = 0
    await toggle_reset(dut.i_rstn)
    cocotb.start_soon(Clock(dut.i_clk, 1, units="ns").start())


async def get_div(dut, x, y):
    await FallingEdge(dut.i_clk)
    dut.i_dividend.value = x
    dut.i_divisor.value = y
    dut.i_start.value = 1
    await FallingEdge(dut.i_clk)
    dut.i_start.value = 0

    await RisingEdge(dut.o_done)
    await FallingEdge(dut.i_clk)

    return dut.o_quotient.value.integer, dut.o_remainder.value.integer


@cocotb.test()
async def test_divider(dut):
    await pre_test(dut)
    x_bits = len(dut.i_dividend)
    y_bits = len(dut.i_divisor)

    x_range = range(2**x_bits)
    y_range = range(1, 2**y_bits)   # Avoid divide by zero

    fail_cnt = 0

    for x, y in itertools.product(x_range, y_range):
        q, r = await get_div(dut, x, y)
        if (q, r) != (x//y, x%y):
            fail_cnt += 1
            cocotb.log.error(f"Failed for ({x}/{y}). Got ({q=}, {r=})")

    assert fail_cnt == 0, f"Total {fail_cnt} failures"
