# Day 04 — 2-Flop CDC Synchronizer

## Question of the Day

### Problem Statement

Write a Verilog module that implements a **2-Flop Synchronizer** for safely transferring a **single-bit asynchronous control signal** into a destination clock domain.

### Module Declaration

```verilog
module top_module(
    input  clk_dest,
    input  reset,
    input  async_in,
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

No combinational logic is placed between the two stages, ensuring maximum settling time and improving synchronization reliability. The synchronized output is taken from the second flip-flop, which significantly reduces the probability of metastability propagating into the destination clock domain.

---

## Key Learning

- Understood the concept of **Clock Domain Crossing (CDC)** and why synchronization is required between different clock domains.
- Learned that metastability occurs when an asynchronous input violates the setup or hold time of the destination flip-flop.
- Implemented a **2-Flop Synchronizer** to reduce the probability of metastability propagating through the design.
- Learned that a synchronizer **reduces** metastability probability but **cannot completely eliminate** it.
- Understood why no combinational logic should be inserted between the two synchronizer flip-flops.
- Learned that RTL simulation cannot model metastability because it is an analog phenomenon occurring at the transistor level.
- Understood the concept of **Mean Time Between Failures (MTBF)** and how providing more settling time improves synchronizer reliability.
- Learned that a basic 2-flop synchronizer is suitable for **single-bit control signals** but is not intended for synchronizing multi-bit data buses or high-speed pulse transfers.

---

## Simulation Result

✔ Successfully synchronizes the asynchronous input into the destination clock domain.

✔ Verified that the synchronized output follows the asynchronous input after passing through the two synchronization stages.

✔ Reset operation initializes both synchronizer flip-flops correctly.

✔ Confirmed that no combinational logic exists between the synchronization stages.

✔ Verified the expected one-clock-cycle synchronization behavior using simulation waveforms.

---

## Interview Notes

A basic **2-Flop Synchronizer** works well for synchronizing **single-bit control signals**, but it is not always sufficient for every Clock Domain Crossing application.

- A continuously toggling or narrow pulse signal may be missed or sampled multiple times when crossing between different clock domains.
- For reliable single-pulse transfer across clock domains, a **Toggle Synchronizer (Pulse Synchronizer)** is commonly used instead of a simple level synchronizer.
- The two synchronizer flip-flops should be placed physically close together in the layout to maximize the available settling time and improve synchronization reliability.
- Metastability cannot be observed in RTL simulation because simulators model ideal digital logic, whereas metastability is an analog hardware phenomenon.
- Increasing the available settling time improves the synchronizer's **Mean Time Between Failures (MTBF)**, making metastability-induced failures significantly less likely.
