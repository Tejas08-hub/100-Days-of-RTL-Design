# Day 01 — 4-bit Synchronous Up-Down Counter

## Question of the Day

### Problem Statement

Write a Verilog module named `top_module` that implements a **4-bit synchronous up/down counter** with a synchronous active-high reset.

### Module Declaration

```verilog
module top_module(
    input        clk,
    input        reset,     // synchronous, active high
    input        up_down,   // 1 = count up, 0 = count down
    output reg [3:0] count
);
```

### Requirements

- The counter is updated on the **rising edge** of `clk`.
- If `reset` is HIGH, synchronously reset the counter to `4'b0000`.
- If `up_down = 1`, increment the counter.
- If `up_down = 0`, decrement the counter.
- The counter should wrap around naturally:
  - `1111 → 0000` while counting up.
  - `0000 → 1111` while counting down.
- Use **non-blocking assignments (`<=`)**.
- Do not use combinational `always` blocks or continuous assignments.

---

## My Approach

Implemented the design using a clocked `always @(posedge clk)` block with a synchronous reset. The counter increments or decrements based on the `up_down` control signal, while the fixed 4-bit width naturally provides wrap-around behavior without additional logic.

---

## Key Learning

- Difference between synchronous and asynchronous reset.
- Proper usage of non-blocking assignments (`<=`) in sequential logic.
- Counters automatically wrap around because of fixed register width.
- Sequential circuits should be implemented using clocked `always` blocks.

---

## Simulation Result

✔ Counter resets correctly.

✔ Counter increments correctly.

✔ Counter decrements correctly.

✔ Wrap-around behavior verified.
