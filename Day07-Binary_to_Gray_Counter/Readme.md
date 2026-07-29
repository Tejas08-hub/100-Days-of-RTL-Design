# Day 07 — Gray Code Counter (Why Async FIFOs Need It)

## Question of the Day

### Problem Statement

Write a Verilog module that implements an **N-bit Gray Code Counter** using an internal binary counter. The output must follow the Gray code sequence, where **only one bit changes between consecutive values**.

### Module Declaration

```verilog
module top_module #(
    parameter WIDTH = 4
)(
    input                  clk,
    input                  reset,   // synchronous, active high
    input                  en,      // count enable
    output [WIDTH-1:0] gray_out
);
```

### Requirements

- Implement an **N-bit Gray code counter**.
- Use an **internal binary counter** and convert it to Gray code.
- Generate Gray code using the standard formula:

  ```text
  Gray = Binary ^ (Binary >> 1)
  ```

- Do **not** increment Gray code directly.
- Use a **synchronous active-high reset**.
- Increment the counter only when **en = 1**.
- Use **non-blocking assignments (`<=`)** inside sequential logic.
- Verify that **exactly one bit changes** between consecutive Gray code outputs using a self-checking testbench.

---

## My Approach

Designed the Gray code counter by maintaining an **internal binary counter** and generating the Gray code output using combinational logic.

Instead of incrementing Gray code directly, the binary counter performs the arithmetic operation while the Gray code is generated using the standard conversion formula.

```text
Gray = Binary ^ (Binary >> 1)
```

This approach simplifies the design because binary numbers support straightforward arithmetic operations, whereas Gray code is only an encoding and is not suitable for direct increment operations.

To verify the correctness of the Gray counter, a self-checking testbench was developed. The previous Gray value was stored, XORed with the current Gray value, and the number of changed bits was counted. Every transition was verified to ensure that exactly **one bit changes** between consecutive Gray code values.

---

## Key Learning

- Learned why **Gray code** is preferred over binary counters in asynchronous clock domain crossings.
- Understood that **Gray code guarantees only one bit changes** between consecutive values.
- Learned that binary counters are used internally because **Gray code cannot be incremented directly**.
- Implemented Binary-to-Gray conversion using:

  ```text
  Gray = Binary ^ (Binary >> 1)
  ```

- Understood how Gray-coded pointers are synchronized safely in **Asynchronous FIFOs**.
- Learned that only **FIFO pointers** are Gray coded and synchronized, while the actual FIFO data is transferred normally.
- Verified the one-bit transition property using an XOR-based verification technique in the testbench.

---

## Why Gray Code is Required in Async FIFOs

An asynchronous FIFO operates with **independent read and write clocks**.

If a binary pointer crosses from one clock domain to another, multiple bits may change simultaneously.

Example:

```text
Binary

0111
 ↓
1000
```

Four bits change at the same time.

If the receiving clock samples during this transition, it may observe an invalid intermediate value, resulting in an incorrect FIFO pointer.

Gray code eliminates this problem because **only one bit changes between adjacent values**.

Example:

```text
Gray

0100
 ↓
1100
```

Only one bit changes, making pointer synchronization significantly safer across clock domains.

---

## Verification Method

To verify the Gray counter:

- Stored the previous Gray code value.
- XORed the previous and current Gray values.
- Counted the number of set bits in the XOR result.
- Confirmed that every valid transition changes **exactly one bit**.

This verification proves the fundamental property that makes Gray code suitable for asynchronous FIFO pointer synchronization.

---

## Simulation Result

✔ Gray code sequence generated correctly.

✔ Binary-to-Gray conversion verified.

✔ Every consecutive Gray code value differs by exactly **one bit**.

✔ One-bit transition property verified using an XOR-based self-checking testbench.

✔ Counter increments correctly when **en = 1**.

✔ Counter resets correctly with synchronous reset.

✔ Gray code sequence and verification successfully confirmed through Vivado simulation waveforms.
