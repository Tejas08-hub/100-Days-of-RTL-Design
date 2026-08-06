# Day 15 — 4-bit LFSR (Pseudo-Random Sequence Generator)

## Question of the Day

### Problem Statement

Write a Verilog module that implements a **4-bit Fibonacci Linear Feedback Shift Register (LFSR)** capable of generating a **maximal-length pseudo-random sequence**.

### Module Declaration

```verilog
module top_module(
    input        clk,
    input        reset,
    output reg [3:0] lfsr_out
);
```

### Requirements

- Implement a **4-bit Fibonacci LFSR**.
- Use a **synchronous active-high reset**.
- On reset, initialize the LFSR with a **non-zero seed** (e.g., `4'b0001`).
- Compute the feedback bit using **XOR of bit 3 and bit 2**.
- Shift the register every positive clock edge and insert the feedback bit.
- Generate a **maximal-length sequence** consisting of all **15 non-zero states** before repeating.
- Ensure the LFSR **never enters the all-zero state (`0000`)**.
- Verify the design using simulation and a **self-checking testbench**.

---

## My Approach

Designed the pseudo-random sequence generator using a **4-bit Fibonacci Linear Feedback Shift Register (LFSR)**.

The implementation consists of:

- **4-bit Shift Register** – Stores the current LFSR state.
- **Feedback Logic** – Computes the new feedback bit using the XOR of bit 3 and bit 2.
- **Shift Operation** – On every rising edge of the clock, all bits shift by one position while the feedback bit is inserted into the least significant position.
- **Reset Logic** – Loads a non-zero seed (`4'b0001`) during reset to avoid the all-zero lock-up state.

The selected feedback taps correspond to a **maximal-length polynomial**, allowing the LFSR to generate all **15 possible non-zero states** before the sequence repeats. A self-checking testbench was used to automatically verify that the sequence never enters the all-zero state and that every non-zero state appears exactly once before repetition.

---

## Key Learning

- Understood the working principle of a **Linear Feedback Shift Register (LFSR)**.
- Learned how **feedback taps** determine the generated sequence.
- Understood why an LFSR requires a **non-zero seed** during initialization.
- Learned that the **all-zero state is a lock-up state** from which the LFSR cannot recover.
- Implemented a **4-bit maximal-length Fibonacci LFSR** using XOR feedback.
- Learned the meaning of a **maximal-length sequence**, where all possible non-zero states are visited exactly once before repeating.
- Understood the difference between **true random** and **pseudo-random** sequence generation.
- Learned why LFSRs are widely used in **Logic Built-In Self-Test (LBIST)**, **CRC generation**, **data scrambling**, and **stream cipher applications**.
- Verified the generated sequence using a **self-checking testbench** instead of relying solely on waveform inspection.

---

## Simulation Result

✔ Successfully initialized the LFSR with a non-zero seed.

✔ Verified correct feedback generation using XOR of the selected tap bits.

✔ Successfully generated all **15 unique non-zero states**.

✔ Confirmed that the sequence repeats only after completing the maximal-length cycle.

✔ Verified that the LFSR **never enters the all-zero state (`0000`)**.

✔ Self-checking testbench automatically detected any invalid sequence or premature repetition.

✔ Verified the expected pseudo-random sequence using simulation waveforms.

---

# Part B — Conceptual Understanding

## Why must the LFSR be initialized with a non-zero seed?

An LFSR generates the next state by computing a feedback bit from the current register contents.

If the register is initialized to:

```text
0000
```

then:

```text
feedback = 0 XOR 0 = 0
```

After shifting,

```text
0000 → 0000 → 0000 → ...
```

The register becomes permanently stuck in the **all-zero lock-up state**. Therefore, every practical LFSR must be initialized with a **non-zero seed**.

---

## What is a Maximal-Length Sequence?

A 4-bit register can represent:

```text
2⁴ = 16 states
```

Since the all-zero state cannot participate in the sequence, only:

```text
16 − 1 = 15 non-zero states
```

are available.

A **maximal-length LFSR** visits **all 15 non-zero states exactly once** before repeating the sequence.

Whether an LFSR is maximal-length depends entirely on selecting the correct **feedback tap positions**, which are derived from **primitive polynomials**.

---

## Why does the all-zero state never appear?

Once the LFSR starts from any non-zero state and uses a valid maximal-length feedback polynomial, the generated sequence forms a closed loop of all non-zero states.

The all-zero state is isolated because:

```text
0000 → feedback = 0 → 0000
```

It transitions only to itself and therefore cannot be reached from any valid non-zero state.

---

## Why is an LFSR called "Pseudo-Random"?

The generated sequence appears random but is actually **deterministic**.

For the same:

- Initial seed
- Feedback tap positions

the LFSR always produces the **exact same sequence**.

This reproducibility makes LFSRs ideal for hardware testing and digital communication systems.

---

## Why is an LFSR preferred over a True Random Generator in BIST?

During chip testing, engineers need to reproduce failing test patterns.

A **true random generator** produces different patterns every execution, making failures difficult to debug.

An LFSR generates **deterministic pseudo-random patterns**, allowing the exact same test sequence to be reproduced whenever the same seed is used.

This reproducibility is essential for **Logic Built-In Self-Test (LBIST)**.

---

## How are Feedback Taps Selected?

Feedback taps are **not chosen randomly**.

They are selected from published **primitive polynomial tables**, which guarantee maximal-length sequences for a given register width.

For larger LFSRs (8-bit, 16-bit, 32-bit, etc.), engineers choose tap positions based on these primitive polynomials to ensure optimal sequence length.

---

## Applications of LFSR

LFSRs are widely used in digital systems, including:

- Logic Built-In Self-Test (LBIST)
- Pseudo-Random Pattern Generation (PRPG)
- Multiple Input Signature Register (MISR)
- Cyclic Redundancy Check (CRC)
- Data Scrambling and Descrambling
- Stream Ciphers
- Error Detection and Correction
- Digital Communication Systems

---

## Additional Interview Concepts

### What determines the sequence generated by an LFSR?

The generated sequence depends on:

- The **feedback tap positions**
- The **initial seed value**

Changing the tap positions changes the feedback polynomial and may produce a shorter or maximal-length sequence.

Changing only the seed (while keeping the taps fixed) starts the sequence from a different point in the same cycle.

---

### Why is XOR used in the feedback path?

XOR is a **linear operation** in binary arithmetic (GF(2)), making it suitable for implementing the feedback polynomial required by an LFSR.

---

### What is the difference between a Fibonacci and a Galois LFSR?

- **Fibonacci LFSR** computes the feedback externally and inserts it into one end of the shift register.
- **Galois LFSR** distributes the feedback internally across multiple stages.

Both can generate the same maximal-length sequences but differ in hardware implementation and timing characteristics.

---

## Conclusion

This project demonstrates the implementation of a **4-bit Fibonacci Linear Feedback Shift Register (LFSR)** for pseudo-random sequence generation. The design generates a **maximal-length sequence of 15 unique non-zero states** using XOR feedback while avoiding the all-zero lock-up condition through proper initialization. A **self-checking testbench** verifies the correctness of the generated sequence by ensuring that all non-zero states appear exactly once before repetition. Along with the RTL implementation, this exercise reinforces important concepts related to **pseudo-random pattern generation, maximal-length sequences, primitive polynomials, Logic Built-In Self-Test (LBIST), CRC generation, and digital communication systems**.
