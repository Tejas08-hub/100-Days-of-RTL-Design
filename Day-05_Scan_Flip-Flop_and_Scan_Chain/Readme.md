# Day 05 — Scan Flip-Flop and 4-bit Scan Chain

## Question of the Day

### Problem Statement

Design a **Scan Flip-Flop** and use it to build a **4-bit Scan Chain**, one of the fundamental Design-for-Testability (DFT) structures used in digital integrated circuits.

### Part A – Single Scan Flip-Flop

Implement a scan-enabled D flip-flop with the following module declaration:

```verilog
module top_module(
    input clk,
    input reset,
    input se,
    input d,
    input si,
    output reg q
);
```

### Requirements

- Design a **Scan Flip-Flop** by placing a **2:1 Multiplexer** before the D input of a standard D Flip-Flop.
- When **se = 0 (Functional Mode)**, the flip-flop captures the normal data input `d`.
- When **se = 1 (Scan/Test Mode)**, the flip-flop captures the serial scan input `si`.
- Implement a synchronous active-high reset.
- Update the output on the rising edge of the clock.
- Use non-blocking assignments (`<=`).

---

### Part B – 4-bit Scan Chain

Instantiate four Scan Flip-Flops and connect them in a serial scan chain.

```verilog
module top_module(
    input clk,
    input reset,
    input se,
    input [3:0] d,
    input scan_in,
    output scan_out,
    output [3:0] q
);
```

### Requirements

- Instantiate four Scan Flip-Flops.
- Connect the external `scan_in` to the first Scan Flip-Flop.
- Connect the output of each flip-flop to the scan input of the next flip-flop.
- Connect the output of the final flip-flop to `scan_out`.
- When **se = 0**, each flip-flop captures its own functional input `d[i]`.
- When **se = 1**, the complete circuit behaves as a **4-bit Shift Register**, shifting serial data through the scan chain.

---

## My Approach

Designed the solution in two stages.

### Stage 1 – Scan Flip-Flop

Implemented a reusable **Scan Flip-Flop** consisting of:

- A 2:1 Multiplexer
- A positive-edge-triggered D Flip-Flop
- Synchronous active-high reset

The multiplexer selects between:

- Functional data input (`d`) during normal operation.
- Scan input (`si`) during test mode.

Selection is controlled using the **Scan Enable (SE)** signal.

- **SE = 0** → Functional Mode
- **SE = 1** → Scan/Test Mode

The selected input is then stored by the D Flip-Flop on the rising edge of the clock.

---

### Stage 2 – Scan Chain

Created a **4-bit Scan Chain** by instantiating four Scan Flip-Flops.

The serial connections are:

```
scan_in → FF1 → FF2 → FF3 → FF4 → scan_out
```

Each flip-flop also receives its own independent functional input:

```
d[0]
d[1]
d[2]
d[3]
```

This allows the circuit to operate in two different modes depending on the Scan Enable signal.

---

## Working Principle

### Functional Mode (SE = 0)

The multiplexer selects the functional input.

Each flip-flop behaves exactly like a normal D Flip-Flop.

```
Q0 <= D0
Q1 <= D1
Q2 <= D2
Q3 <= D3
```

All four bits are loaded simultaneously on the next rising clock edge.

---

### Scan Mode (SE = 1)

The multiplexer selects the scan input.

The four flip-flops become a serial shift register.

```
scan_in
   │
   ▼
FF1 → FF2 → FF3 → FF4 → scan_out
```

With every clock pulse:

- FF1 captures the external scan input.
- FF2 captures the previous value of FF1.
- FF3 captures the previous value of FF2.
- FF4 captures the previous value of FF3.
- The previous value stored in FF4 appears at `scan_out`.

This mechanism allows test patterns to be shifted into the circuit and captured data to be shifted back out during manufacturing testing.

---

## Why Scan Flip-Flops are Used

After fabrication, internal flip-flops inside an integrated circuit cannot be accessed directly through chip pins.

A Scan Flip-Flop improves **Design-for-Testability (DFT)** by allowing every internal flip-flop to become part of a serial shift register during test mode.

This enables engineers to:

- Shift known test patterns into internal registers.
- Observe internal register contents through scan chains.
- Detect manufacturing defects.
- Improve production test coverage.

---

## Important DFT Concepts

### Controllability

Controllability is the ability to force an internal flip-flop to any desired logic value.

Using a scan chain, test data can be shifted into every flip-flop, giving complete control over the internal state of the circuit.

---

### Observability

Observability is the ability to view the contents of internal flip-flops.

During scan mode, stored values are shifted out through `scan_out`, allowing engineers to examine internal states without physically probing the chip.

---

### Why is the Multiplexer Placed Before the Flip-Flop?

The multiplexer must be connected to the **D input** of the flip-flop.

This allows the same flip-flop to capture either:

- Functional data during normal operation.
- Scan data during test mode.

If the multiplexer were placed after the flip-flop output, the stored value inside the flip-flop could not be controlled, making scan testing ineffective.

---

### Why are Only Clocked D Flip-Flops Used?

Scan chains require every flip-flop to capture data on a common clock edge.

Using standard edge-triggered D Flip-Flops ensures reliable shifting of scan data throughout the entire chain during testing.

---

### Cost of Scan Design

Adding scan capability is not free.

Each Scan Flip-Flop introduces:

- One additional 2:1 Multiplexer.
- Slight increase in silicon area.
- Small increase in propagation delay.
- Slight increase in power consumption.

Despite these overheads, scan design is widely accepted because it significantly improves chip testability and manufacturing yield.

---

## Key Learning

- Learned the concept of **Design-for-Testability (DFT)**.
- Understood the architecture of a Scan Flip-Flop.
- Learned how a multiplexer enables functional mode and scan mode.
- Implemented a reusable Scan Flip-Flop module.
- Built a complete 4-bit Scan Chain using module instantiation.
- Understood serial shifting of scan data.
- Learned the concepts of Controllability and Observability.
- Understood why scan multiplexers are placed before the flip-flop.
- Learned why edge-triggered D Flip-Flops are preferred in scan chains.
- Understood the trade-off between additional hardware and improved test coverage.

---

## Simulation Result

✔ Functional mode correctly loads parallel data inputs.

✔ Scan mode successfully shifts serial data through the scan chain.

✔ External `scan_in` propagates through all four Scan Flip-Flops.

✔ `scan_out` correctly outputs the final stage of the scan chain.

✔ Synchronous reset clears all flip-flops.

✔ Successfully verified both Functional Mode and Scan Mode using simulation waveforms.

✔ Generated RTL schematic confirming the correct Scan Chain architecture.
