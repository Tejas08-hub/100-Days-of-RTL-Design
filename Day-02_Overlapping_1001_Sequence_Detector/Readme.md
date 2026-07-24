# Day 02 — Overlapping 1001 Sequence Detector (Moore FSM)

## Question of the Day

### Problem Statement

Write a Verilog module that implements an **overlapping sequence detector** for the binary sequence **1001** using a **Moore Finite State Machine (FSM)**.

### Module Declaration

```verilog
module seq_detector(
    input clk,
    input reset,
    input d_in,
    output reg detected
);
```

### Requirements

- Detect the binary sequence **1001**.
- Support **overlapping sequence detection**.
- Implement the design using a **Moore FSM**.
- Use a synchronous active-high reset.
- Update the FSM on the **rising edge** of `clk`.
- Assert `detected` when the complete sequence is detected.
- Use **non-blocking assignments (`<=`)**.
- Implement the FSM using a clocked `always @(posedge clk)` block.

---

## My Approach

Designed the sequence detector as a **Moore Finite State Machine** with **five states**, where each state represents the progress of matching the input sequence.

The implemented states are:

- **NO_MATCH** – No bits matched.
- **ONE_BIT_MATCH** – First bit (`1`) matched.
- **TWO_BIT_MATCH** – First two bits (`10`) matched.
- **THREE_BIT_MATCH** – First three bits (`100`) matched.
- **FOURTH_BIT_MATCH** – Complete sequence (`1001`) detected.

The output `detected` is asserted only in the **FOURTH_BIT_MATCH** state, making the output dependent only on the current state, which is the characteristic of a **Moore FSM**. Overlapping detection is achieved by transitioning to the appropriate state instead of always returning to the initial state after a detection.

---

## Key Learning

- Understood the difference between **Mealy** and **Moore** finite state machines.
- Learned that FSM states represent the **progress of sequence matching**, not the current input bit.
- Designed an **overlapping sequence detector** by selecting appropriate state transitions.
- Implemented a **Moore FSM**, where the output depends only on the current state.
- Learned that Moore FSMs generally require more states than Mealy FSMs but provide stable, synchronous outputs.
- Verified state transitions and sequence detection through simulation.

---

## Simulation Result

✔ FSM transitions through all states correctly.

✔ Successfully detects the sequence **1001**.

✔ Overlapping sequence detection verified.

✔ `detected` is asserted only in the **FOURTH_BIT_MATCH** state.

✔ State transitions and output behavior verified using simulation waveforms.
