# Day 16 — Clock Divider by 3 with 50% Duty Cycle

## Question of the Day

### Problem Statement

Design a Verilog module that implements a **Clock Divider by 3** with an output duty cycle as close as possible to **50%**.

### Module Declaration

```verilog
module top_module(
    input  clk_in,
    input  reset,
    output clk_out
);
```

### Requirements

- Divide the input clock frequency by **3**.
- Generate an output clock with an approximately **50% duty cycle**.
- Use **two mod-3 counters**:
  - One operating on the **positive edge** of `clk_in`.
  - One operating on the **negative edge** of `clk_in`.
- Generate two intermediate divide-by-3 waveforms and combine them using an **OR** operation.
- Use a synchronous active-high reset.
- Verify the output frequency and duty cycle through simulation.
- Measure the **HIGH** and **LOW** durations of `clk_out` in the testbench instead of only observing the waveform.

---

## My Approach

Designed the clock divider using **two independent modulo-3 counters**, one triggered by the **positive edge** of the input clock and the other triggered by the **negative edge**.

Each counter generates its own divide-by-3 waveform. Since the two counters are offset by **half of the input clock period**, their outputs are naturally phase-shifted.

The final output clock is obtained by **OR-ing** the two generated waveforms. The half-clock phase difference extends the HIGH duration of the output signal, producing an output clock with a duty cycle much closer to **50%** than can be achieved using only a single edge of the clock.

A self-checking testbench was developed to calculate and display the HIGH and LOW durations of the generated clock, verifying that the duty cycle satisfies the design requirement.

---

## Key Learning

- Learned why **odd clock division** cannot generate a perfect 50% duty cycle using only the positive edge of a clock.
- Understood that dividing by an odd number requires **half-clock resolution**, which is obtained by using both positive and negative clock edges.
- Learned how two phase-shifted divide-by-3 waveforms can be combined using an **OR gate** to obtain an approximately 50% duty cycle.
- Understood the difference between generating a **pulse** and generating a **clock waveform**.
- Learned that **frequency** depends on how often a waveform repeats, while **duty cycle** depends on the ratio of HIGH and LOW durations.
- Implemented a self-checking testbench to calculate HIGH time and LOW time instead of manually inspecting the waveform.
- Understood that generated clocks should be carefully verified before being used as clock sources in larger designs.

---

## Interview Questions & Answers

### 1. Why can't a divide-by-3 clock achieve a perfect 50% duty cycle using only the positive edge?

A divide-by-3 clock period consists of **3 input clock cycles**. A 50% duty cycle requires the output to remain HIGH for **1.5 cycles** and LOW for **1.5 cycles**, which is impossible when the output can only change on positive clock edges.

---

### 2. Why are two counters required?

One counter operates on the **positive edge** and the other on the **negative edge** of the input clock. Since the two counters are separated by **half a clock period**, their outputs are phase shifted, providing the additional half-clock timing resolution required to generate a near 50% duty cycle.

---

### 3. Why are the two outputs OR-ed together?

Each counter individually produces a divide-by-3 waveform with an uneven duty cycle. OR-ing the two phase-shifted waveforms extends the HIGH duration by **half a clock period**, resulting in an output clock that is much closer to a 50% duty cycle.

---

### 4. Why is this technique unnecessary for divide-by-2 or divide-by-4?

Even divisors can be evenly split into identical HIGH and LOW durations.

For example:

- Divide-by-2 → HIGH = 1 cycle, LOW = 1 cycle
- Divide-by-4 → HIGH = 2 cycles, LOW = 2 cycles

Since the HIGH and LOW durations are already equal, only a single-edge counter is required.

---

### 5. Is the generated clock always safe to use as another clock source?

Not necessarily. Since the output clock is generated using combinational logic (OR gate), it should be carefully verified for glitches, timing behavior, and synthesis implementation before being used to drive another clock domain in a real design.

---

### 6. Why does frequency remain divided by 3 even after OR-ing the two signals?

The OR operation changes only the **HIGH duration** of the waveform. The complete output waveform still repeats once every **three input clock cycles**, so the output frequency remains **clk_in / 3**.

---

### 7. What is the difference between frequency and duty cycle?

- **Frequency** determines how often a waveform repeats.
- **Duty cycle** determines the percentage of one period during which the signal remains HIGH.

Changing the duty cycle does **not** change the frequency.

---

### 8. Why is measuring the duty cycle in the testbench important?

A waveform may visually appear to have a 50% duty cycle, but actual timing measurements provide quantitative verification. Measuring the HIGH and LOW durations ensures that the design meets the specified duty-cycle requirement.

---

## Simulation Result

✔ Successfully divides the input clock frequency by **3**.

✔ Generated output clock achieves an approximately **50% duty cycle**.

✔ Positive-edge and negative-edge counters operate correctly with a half-clock phase offset.

✔ HIGH and LOW durations were measured in the testbench and verified to be equal (or within the allowed tolerance).

✔ Waveforms confirm correct divide-by-3 operation and proper duty-cycle generation.

✔ Self-checking testbench successfully validates both frequency division and duty-cycle accuracy.
