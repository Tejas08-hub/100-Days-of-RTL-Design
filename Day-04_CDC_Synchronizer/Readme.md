# Day 04 — 2-Flop CDC Synchronizer

## Question of the Day

### Problem Statement

Write a Verilog module that implements a **2-Flop Synchronizer** for safely transferring a **single-bit asynchronous control signal** into a destination clock domain.

### Module Declaration

```verilog
module top_module(
    input  clk_dest,
    input  reset,        // synchronous, active high
    input  async_in,     // asynchronous signal
    output sync_out
);
```

### Requirements

- Implement a classic **2-Flop Synchronizer** using two flip-flops connected in series.
- Both flip-flops must be clocked by the **destination clock (`clk_dest`)**.
- Use a synchronous active-high reset.
- Do **not** place any combinational logic between the two flip-flops.
- The output `sync_out` must be driven by the second flip-flop.
- Use **non-blocking assignments (`<=`)**.
- Implement the design using a clocked `always @(posedge clk_dest)` block.

---

## My Approach

Designed the synchronizer using **two cascaded flip-flops** operating in the destination clock domain.

The implementation consists of:

- **Stage 1 Flip-Flop** – Samples the asynchronous input signal. If the input changes close to the destination clock edge, this flip-flop may temporarily enter a metastable state.
- **Stage 2 Flip-Flop** – Samples the output of the first flip-flop one destination clock cycle later, allowing the first stage sufficient time to settle to a valid logic level before the synchronized signal is used by the rest of the design.

The synchronized output is taken from the second flip-flop. No combinational logic is placed between the two synchronization stages, ensuring maximum settling time and improving synchronization reliability.

---

## Key Learning

- Understood the concept of **Clock Domain Crossing (CDC)** and why synchronization is required between different clock domains.
- Learned that metastability occurs when an asynchronous input violates the setup or hold time of the destination flip-flop.
- Implemented a **2-Flop Synchronizer** to reduce the probability of metastability propagating through the design.
- Learned that a synchronizer **reduces** the probability of metastability but **cannot completely eliminate** it.
- Understood why no combinational logic should be inserted between the two synchronizer flip-flops.
- Learned that RTL simulation cannot model metastability because it is an analog phenomenon occurring at the transistor level.
- Understood the concept of **Mean Time Between Failures (MTBF)** and how providing more settling time improves synchronizer reliability.
- Learned that a basic 2-flop synchronizer is suitable for **single-bit control signals** but is not intended for synchronizing multi-bit data buses.

---

## Simulation Result

✔ Successfully synchronizes the asynchronous input into the destination clock domain.

✔ Verified that the synchronized output follows the asynchronous input after passing through the two synchronization stages.

✔ Reset operation initializes both synchronizer flip-flops correctly.

✔ Confirmed that no combinational logic exists between the synchronization stages.

✔ Verified the expected synchronization behavior using simulation waveforms.

---

# Part B — Conceptual Understanding

## Why is a 2-Flop Synchronizer Not Always Enough?

A basic **2-Flop Synchronizer** is designed to safely synchronize **single-bit control signals** between different clock domains by reducing the probability of metastability. However, it is **not suitable for every Clock Domain Crossing (CDC) scenario**.

Consider a signal crossing from a **20 MHz source clock** to a **100 MHz destination clock**. If the source signal is continuously toggling or generates very narrow pulses, a simple level synchronizer may not capture every transition correctly.

This can lead to:

- Missing transitions if the pulse is shorter than the destination sampling interval.
- Detecting the same transition multiple times when the destination clock samples the same signal level repeatedly.
- Incorrect event detection even though metastability has been reduced.

Therefore, while a 2-flop synchronizer safely transfers **signal levels**, it does not reliably transfer **events or pulses**.

---

## Standard Solution — Toggle Synchronizer

For reliable transfer of a **single pulse** across different clock domains, a **Toggle Synchronizer** is commonly used.

Instead of directly synchronizing the pulse:

- The source domain toggles a single-bit signal whenever an event occurs.
- The toggle signal is synchronized into the destination domain using a 2-flop synchronizer.
- The destination detects a change in the synchronized toggle value using edge detection and recreates a single-clock pulse.

This approach ensures that each event is detected exactly once, even when the source and destination clocks operate at different frequencies.

---

## Additional Interview Concepts

### Why are the two synchronizer flip-flops placed physically close together?

The two flip-flops are placed close together during physical design to minimize routing delay between them. This maximizes the settling time available for the first flip-flop before the second flip-flop samples its output, thereby improving synchronization reliability.

### Why can't metastability be observed in RTL simulation?

RTL simulators model ideal digital logic and do not model the analog behavior of transistors. Since metastability is an analog phenomenon caused by setup or hold time violations inside a flip-flop, it cannot be reproduced in RTL simulation.

### What is MTBF?

**Mean Time Between Failures (MTBF)** is a measure of synchronizer reliability. It represents the average time between metastability-related failures. Increasing the available settling time between the synchronizer flip-flops improves MTBF, making failures significantly less likely.

---

## Conclusion

This project demonstrates the implementation of a **2-Flop CDC Synchronizer**, one of the most fundamental building blocks used in digital VLSI design for safe **Clock Domain Crossing (CDC)**. Along with the RTL implementation, this exercise highlights the practical limitations of a basic synchronizer, the importance of metastability mitigation, and the standard industry techniques such as **Toggle Synchronizers** for reliable event transfer between different clock domains. The design was verified through simulation, and the underlying CDC concepts were studied from both implementation and interview perspectives.
