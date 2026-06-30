# Sequential Restoring Divider

A parameterizable **Sequential Restoring Divider** implemented in **SystemVerilog** and verified using the **Cocotb** Python verification framework. The design uses a finite state machine (FSM) to perform iterative restoring division, producing both quotient and remainder.

---

## Overview

This project implements the restoring division algorithm as a sequential hardware design. Unlike combinational dividers, the operation is performed over multiple clock cycles using a finite state machine, making the design area-efficient and suitable for digital hardware implementations.

The divider is parameterized by operand width and supports configurable data sizes through a SystemVerilog parameter.

---

## Features

- Parameterizable operand width
- Sequential restoring division algorithm
- FSM-based control logic
- Quotient and remainder generation
- Active-low asynchronous reset
- Cocotb-based verification
- Exhaustive functional testing

---

## Design Architecture

```
rtl/
└── divider.sv
```

### Module Description

| Module | Description |
|--------|-------------|
| `divider.sv` | Parameterized sequential restoring divider with FSM-based control |

---

## Finite State Machine

The divider operates using a simple three-state finite state machine.

```
        +------+
        | IDLE |
        +------+
            |
      i_start = 1
            |
            ▼
    +---------------+
    |   DIVIDING    |
    +---------------+
            |
    count == 0
            |
            ▼
       +----------+
       |   DONE   |
       +----------+
            |
            ▼
          IDLE
```

---

## Restoring Division Algorithm

For each clock cycle, the divider performs the following operations:

1. Shift the accumulator and dividend.
2. Compare the accumulator with the divisor.
3. Subtract the divisor if the accumulator is greater than or equal.
4. Shift the quotient and insert the computed quotient bit.
5. Repeat until all bits have been processed.

---

## Interface

### Inputs

| Signal | Width | Description |
|--------|------:|-------------|
| `i_clk` | 1 | System clock |
| `i_rstn` | 1 | Active-low reset |
| `i_dividend` | D_WIDTH | Dividend |
| `i_divisor` | D_WIDTH | Divisor |
| `i_start` | 1 | Starts division operation |

### Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| `o_done` | 1 | Operation complete flag |
| `o_quotient` | D_WIDTH | Computed quotient |
| `o_remainder` | D_WIDTH | Computed remainder |

---

## Verification

The design is verified using the **Cocotb** framework.

```
tb/
└── test_divider.py
```

### Verification Methodology

The testbench:

- Generates a clock and reset
- Starts a division operation
- Waits for the `o_done` signal
- Reads the quotient and remainder
- Compares the hardware output against Python's integer division

```python
quotient  = dividend // divisor
remainder = dividend % divisor
```

### Test Coverage

The verification performs exhaustive testing for all valid input combinations.

For a 4-bit divider:

- Dividend: **0 – 15**
- Divisor: **1 – 15** (division by zero excluded)

Every result is compared against the expected mathematical output.

---

## Repository Structure

```
Sequential-Restoring-Divider/
│
├── README.md
│
├── rtl/
│   └── divider.sv
│
└── tb/
    └── test_divider.py
```

---

## Tools Used

- **SystemVerilog**
- **Cocotb**
- **Python**
- **Icarus Verilog**
- **GTKWave**

---

## Learning Outcomes

This project demonstrates:

- RTL Design using SystemVerilog
- Sequential Arithmetic Circuit Design
- Restoring Division Algorithm
- FSM Design
- Parameterized Hardware Design
- Cocotb-Based Functional Verification
- Python-Driven Hardware Testing
- Exhaustive Verification Methodology

---

## Future Improvements

Potential enhancements include:

- Signed Division Support
- Non-Restoring Division Algorithm
- Radix-4 Divider
- Pipelined Divider Architecture
- UVM-Based Verification
- Synthesis and Timing Analysis

---


