# Day 14 — Glitch-Free Integrated Clock Gating (ICG) Cell

## Question of the Day

### Problem Statement

Design a Verilog module that implements a **Glitch-Free Integrated Clock Gating (ICG) Cell** using a **level-sensitive latch** to safely gate the clock for low-power applications.

### Module Declaration

```verilog
module top_module(
    input  clk,
    input  enable,
    output gated_clk
);
```

### Requirements

- Implement a **glitch-free clock gating cell** using a **level-sensitive latch**.
- The latch must be **transparent only while the clock is LOW**.
- The latched enable signal should be ANDed with the clock to generate the gated clock.
- Do **not** gate the clock directly using `clk & enable`.
- Use a **latch**, not a flip-flop, to capture the enable signal.
- Demonstrate through simulation that changing **enable while the clock is HIGH does not affect the gated clock** until the next LOW phase.
- Compare the latch-based implementation with a **naive AND-gate clock gating** implementation.

---

## My Approach

Designed a **Glitch-Free Integrated Clock Gating (ICG) Cell** using a **negative-level-sensitive latch** followed by an AND gate.

The implementation consists of:

- **Enable Latch** – Samples the enable signal only while the clock is LOW. Once the clock goes HIGH, the latch closes and holds the previously captured enable value.
- **Clock Gating Logic** – The latched enable signal is ANDed with the original clock to generate the gated clock.
- **Glitch Prevention** – Since the enable signal is frozen during the HIGH phase of the clock, any enable transitions occurring while the clock is HIGH cannot propagate through the AND gate, preventing truncated clock pulses.

A comparison was performed between the latch-based ICG cell and a naive clock gating implementation. The simulation verified that the latch-based design eliminates glitches while the naive implementation produces truncated clock pulses when the enable signal changes during the HIGH phase of the clock.

---

## Key Learning

- Understood the purpose of **Clock Gating** in reducing dynamic power consumption.
- Learned why directly gating the clock using an AND gate is unsafe.
- Understood how **glitches (truncated clock pulses)** are generated when the enable signal changes while the clock is HIGH.
- Implemented a **latch-based Integrated Clock Gating (ICG) Cell** to eliminate clock glitches.
- Learned why the enable signal must be sampled only during the LOW phase of the clock.
- Understood why a **negative-level-sensitive latch** is paired with **positive-edge-triggered flip-flops**.
- Learned why an ICG cell uses a **latch instead of a flip-flop**.
- Understood that clock gating reduces unnecessary switching activity in the downstream clock tree and sequential elements, thereby reducing dynamic power consumption.
- Verified glitch-free operation through waveform comparison with a naive AND-gate implementation.

---

## Simulation Result

✔ Successfully implemented a glitch-free latch-based clock gating cell.

✔ Verified that the latch captures the enable signal only during the LOW phase of the clock.

✔ Confirmed that enable transitions during the HIGH phase do not affect the gated clock.

✔ Compared the latch-based ICG cell with a naive AND-gate implementation.

✔ Observed glitches in the naive clock gating implementation when enable changed during the HIGH phase.

✔ Verified that the latch-based ICG generated only complete clock pulses without any truncated pulses.

✔ Verified the expected behavior using simulation waveforms.

---

# Part B — Conceptual Understanding

## Why is a simple AND gate not suitable for Clock Gating?

A naive clock gating implementation such as:

```verilog
assign gated_clk = clk & enable;
```

is purely combinational.

If the **enable** signal changes while the clock is already HIGH, the AND gate immediately responds to the input change, producing a **truncated clock pulse (glitch)**.

Such glitches can violate setup and hold time requirements of downstream flip-flops, potentially causing incorrect data capture or metastability.

Therefore, direct clock gating using an AND gate is not used in practical ASIC and FPGA designs.

---

## Why is a Latch used instead of a Flip-Flop?

A latch is preferred because it is **transparent throughout the LOW phase** of the clock, allowing the enable signal to settle before the next clock pulse begins.

When the clock becomes HIGH, the latch closes and holds the enable value constant.

This ensures that the AND gate always receives a stable enable signal during the entire HIGH phase of the clock, preventing glitches.

Compared to a flip-flop, a latch:

- Uses fewer transistors.
- Occupies less silicon area.
- Consumes less power.
- Naturally fits the timing requirements of Integrated Clock Gating cells.

Although latches are generally avoided in RTL design because of timing complexity, **Integrated Clock Gating (ICG)** is one of the standard exceptions where latches are intentionally used.

---

## Why is a Negative-Level Latch used?

For systems using **positive-edge-triggered flip-flops**, the latch must remain transparent only while the clock is LOW.

This allows the enable signal to be captured before the rising edge.

During the HIGH phase, the latch is closed and the enable signal cannot change, ensuring that the gated clock remains glitch-free.

If a positive-level-sensitive latch were used instead, the enable signal could continue changing while the clock is HIGH, allowing glitches to propagate through the AND gate.

---

## How does Clock Gating reduce Power?

Dynamic power consumption is given by:

```text
P = αCV²f
```

where:

- α = Switching Activity
- C = Load Capacitance
- V = Supply Voltage
- f = Clock Frequency

Clock signals toggle continuously and drive a large number of flip-flops and buffers.

When a block is idle, clock gating prevents the clock from propagating into that block.

As a result:

- Downstream flip-flops stop toggling.
- Clock tree buffers stop switching.
- Unnecessary internal switching activity is eliminated.

This significantly reduces dynamic power consumption without affecting functional behavior.

---

## Additional Interview Concepts

### Why does the naive AND gate produce glitches?

An AND gate is a **combinational circuit** and continuously evaluates both inputs.

If the enable signal changes while the clock is HIGH, the output changes immediately, creating a shortened clock pulse.

---

### What happens when enable changes while the clock is LOW?

The latch is transparent during the LOW phase.

Therefore, it safely captures the new enable value before the next clock pulse begins.

When the clock becomes HIGH, the latch closes and holds that value until the next LOW phase.

---

### Why doesn't the latch require an `else` statement?

When the condition

```verilog
if(!clk)
```

is false, the latch must retain its previous value.

The absence of the `else` branch causes the synthesis tool to infer a **level-sensitive latch**, which naturally stores the previous enable value.

---

### Why doesn't a missing `else` infer a latch inside `always @(posedge clk)`?

An edge-triggered `always @(posedge clk)` block already represents a flip-flop.

If no assignment occurs during a clock edge, the flip-flop simply retains its previous value.

Therefore, omitting the `else` in sequential logic creates an **enable flip-flop**, not a latch.

---

### Why is Clock Gating preferred over simply disabling data inputs?

If only the data path is disabled, the clock still toggles every cycle.

Clock gating stops the clock itself from propagating into inactive logic, eliminating unnecessary switching inside both the flip-flops and the downstream clock distribution network.

This provides significantly greater dynamic power savings.

---

## Conclusion

This project demonstrates the implementation of a **Glitch-Free Integrated Clock Gating (ICG) Cell**, a fundamental low-power design technique used in modern ASICs and SoCs. By using a **negative-level-sensitive latch** to capture the enable signal, the design guarantees that the gated clock is free from truncated pulses and glitches. The comparison with a naive AND-gate implementation highlights why latch-based clock gating is the industry-standard solution. Along with the RTL implementation, this exercise reinforces important concepts such as latch inference, glitch prevention, clock tree power optimization, and dynamic power reduction through clock gating. The design was successfully verified using simulation and waveform comparison.
