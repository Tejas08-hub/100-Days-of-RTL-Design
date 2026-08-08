# Day 17 — 32-bit Barrel Shifter

## Question of the Day

### Problem Statement

Design a **32-bit combinational barrel shifter** that can perform a logical left or right shift by any amount from **0 to 31 in a single combinational path**.

Unlike a simple shift register that moves data one bit at a time over multiple clock cycles, a barrel shifter uses multiple **MUX stages** to perform an arbitrary shift in one cycle.

### Module Declaration

```verilog
module top_module(
    input  [31:0] data_in,
    input  [4:0]  shift_amt,
    input         direction,
    output [31:0] data_out
);
```

### Requirements

- Design a purely **combinational** barrel shifter.
- Do not use a clock or reset.
- Support shift amounts from **0 to 31**.
- Support both logical left and logical right shifts.
- Use **5 MUX stages** because `shift_amt` contains 5 bits.
- Each stage must shift by a power-of-two amount:
  - Stage 1 → 1 bit
  - Stage 2 → 2 bits
  - Stage 3 → 4 bits
  - Stage 4 → 8 bits
  - Stage 5 → 16 bits
- Each stage either:
  - Passes the previous data unchanged, or
  - Shifts the previous data by its corresponding amount.
- Use `shift_amt[i]` to control whether stage `i` performs its shift.
- `direction = 0` → Logical left shift.
- `direction = 1` → Logical right shift.
- Vacated bit positions must be filled with zeros.
- Verify different shift amounts and both shift directions through simulation.

---

## My Approach

Designed the barrel shifter using **five cascaded combinational MUX stages**.

Each stage receives the output of the previous stage and provides two possible paths:

1. The previous value without shifting.
2. The previous value shifted by the stage's assigned power-of-two amount.

The corresponding bit of `shift_amt` selects between these two paths.

The five stages are:

```text
Stage 1 → Shift by 1
Stage 2 → Shift by 2
Stage 3 → Shift by 4
Stage 4 → Shift by 8
Stage 5 → Shift by 16
```

The shift amount is therefore constructed from the binary representation of `shift_amt`.

For example:

```text
shift_amt = 5'b00101
```

represents:

```text
1 + 4 = 5
```

Therefore:

```text
Stage 1 → Shift by 1
Stage 2 → No shift
Stage 3 → Shift by 4
Stage 4 → No shift
Stage 5 → No shift
```

The final output of Stage 5 is connected to `data_out`.

---

## Barrel Shifter Architecture

The design can be represented as:

```text
                    shift_amt[0]
                         │
                         ▼
data_in ─────────────► Stage 1 ──────► stage1
                       Shift 1

                    shift_amt[1]
                         │
                         ▼
stage1 ───────────────► Stage 2 ──────► stage2
                       Shift 2

                    shift_amt[2]
                         │
                         ▼
stage2 ───────────────► Stage 3 ──────► stage3
                       Shift 4

                    shift_amt[3]
                         │
                         ▼
stage3 ───────────────► Stage 4 ──────► stage4
                       Shift 8

                    shift_amt[4]
                         │
                         ▼
stage4 ───────────────► Stage 5 ──────► stage5
                       Shift 16

                                      │
                                      ▼
                                  data_out
```

Each stage behaves conceptually like a **2:1 multiplexer**:

```text
                 ┌── Previous Data ──────┐
Previous Data ───┤                       ├──► Next Stage
                 └── Shifted Data ───────┘
                            ▲
                       shift_amt[i]
```

The `direction` signal determines whether the shifted path performs a left shift or right shift.

---

## Working Principle

### Stage 1 — Shift by 1

The first stage checks `shift_amt[0]`.

```text
shift_amt[0] = 0 → No shift
shift_amt[0] = 1 → Shift by 1
```

The direction determines whether the operation is:

```text
Left  → << 1
Right → >> 1
```

---

### Stage 2 — Shift by 2

Stage 2 operates on the output of Stage 1.

```text
shift_amt[1] = 0 → No shift
shift_amt[1] = 1 → Shift by 2
```

---

### Stage 3 — Shift by 4

```text
shift_amt[2] = 0 → No shift
shift_amt[2] = 1 → Shift by 4
```

---

### Stage 4 — Shift by 8

```text
shift_amt[3] = 0 → No shift
shift_amt[3] = 1 → Shift by 8
```

---

### Stage 5 — Shift by 16

```text
shift_amt[4] = 0 → No shift
shift_amt[4] = 1 → Shift by 16
```

After the five stages, any shift amount from **0 to 31** can be generated.

---

## Example

Consider:

```text
data_in  = 10
shift_amt = 5
direction = 0
```

Since:

```text
5 = 4 + 1
```

the active stages are:

```text
Stage 1 → Shift by 1
Stage 2 → No shift
Stage 3 → Shift by 4
Stage 4 → No shift
Stage 5 → No shift
```

Therefore:

```text
10 << 5 = 320
```

For a right shift:

```text
data_in  = 100
shift_amt = 3
direction = 1
```

The result is:

```text
100 >> 3 = 12
```

The shift is performed through the appropriate combination of the 1-bit and 2-bit stages.

---

## Why Five Stages?

A 32-bit barrel shifter needs to support shift amounts from:

```text
0 to 31
```

There are **32 possible shift values**.

Since:

```text
2^5 = 32
```

five control bits are required.

Each bit represents a power-of-two shift:

```text
2^0 = 1
2^1 = 2
2^2 = 4
2^3 = 8
2^4 = 16
```

Any number from 0 to 31 can be represented by combining these values.

For example:

```text
13 = 8 + 4 + 1
```

Therefore, a shift amount of 13 activates the:

```text
1-bit stage
4-bit stage
8-bit stage
```

---

## Why is it Called a Barrel Shifter?

A barrel shifter can shift a data word by an **arbitrary number of positions in a single combinational operation**.

Unlike a simple shift register, the data does not have to physically move one bit at a time over multiple clock cycles.

The network of multiplexers allows different combinations of shifts to be selected simultaneously, giving the circuit its characteristic barrel-shifter structure.

---

## Barrel Shifter vs Shift Register

### Barrel Shifter

```text
Input
  │
  ▼
MUX Stage 1
  │
  ▼
MUX Stage 2
  │
  ▼
MUX Stage 3
  │
  ▼
MUX Stage 4
  │
  ▼
MUX Stage 5
  │
  ▼
Output
```

- Combinational.
- Arbitrary shift in one operation.
- No clock required.
- Used in CPUs, ALUs, DSPs and datapaths.
- Requires more combinational hardware.

### Shift Register

```text
FF → FF → FF → FF → FF
```

- Sequential.
- Usually shifts by one position per clock.
- Requires multiple clock cycles for a large shift.
- Stores data between clock cycles.
- Useful for serial data transfer, delay lines and shift-based protocols.

---

## Why O(log N) Logic Depth?

For a 32-bit barrel shifter, the design contains:

```text
log2(32) = 5
```

MUX stages.

Therefore, the maximum combinational depth is approximately:

```text
5 MUX levels
```

rather than requiring 32 sequential one-bit shifting operations.

For a general N-bit power-of-two barrel shifter:

```text
Number of stages = log2(N)
```

This is the main structural advantage of the barrel-shifter architecture.

---

## Logical Shift vs Arithmetic Shift

This design performs **logical shifting**.

### Logical Left Shift

Zeros enter from the right:

```text
10110010 << 2

11001000
```

### Logical Right Shift

Zeros enter from the left:

```text
10110010 >> 2

00101100
```

An arithmetic right shift would instead preserve the sign bit for signed two's-complement data.

For example:

```text
11110000 >>> 2

11111100
```

That behavior is intentionally not implemented in this challenge.

---

## Important Concepts

### 1. Combinational Logic

The barrel shifter has no clock or storage elements.

The output changes whenever:

- `data_in` changes.
- `shift_amt` changes.
- `direction` changes.

---

### 2. MUX-Based Design

Every stage behaves like a 2:1 MUX.

The MUX selects between:

```text
Unshifted data
```

and

```text
Shifted data
```

using the corresponding `shift_amt` bit.

---

### 3. Multiple Stage Activation

Multiple stages can be active at the same time.

For example:

```text
shift_amt = 5'b11111
```

activates:

```text
1 + 2 + 4 + 8 + 16 = 31
```

Therefore, the maximum supported shift is **31 bits**.

---

### 4. Why is `shift_amt` 5 Bits?

A 5-bit unsigned value can represent:

```text
00000 = 0
...
11111 = 31
```

Therefore, the 5-bit input structurally limits the requested shift amount to the valid range of a 32-bit word.

---

## What Happens if Shift Amount Exceeds 31?

The current interface uses:

```verilog
input [4:0] shift_amt;
```

so only values from **0 to 31** can be represented.

If a wider 6-bit value were used, values from 32 to 63 could also be represented. Those values would require an additional stage or explicit handling.

For this design, the 5-bit width prevents such values from being directly represented.

---

## How Would a Rotate Operation Differ?

A logical shift discards the bits that leave the word and fills the empty positions with zeros.

A **rotate** operation instead wraps the discarded bits around to the opposite side.

For example:

```text
10110010
```

Rotating left by 2:

```text
11001010
```

The structural change is that each MUX stage would select between:

```text
Unchanged data
```

and

```text
Rotated data
```

instead of:

```text
Unchanged data
```

and

```text
Zero-filled shifted data
```

The same five-stage MUX architecture can therefore be extended to support rotation.

---

## Interview Questions & Answers

### 1. Why does a barrel shifter use 5 stages for 32-bit data?

Because:

```text
log2(32) = 5
```

Five binary control bits are sufficient to represent every shift amount from 0 to 31.

---

### 2. Why are the shift amounts 1, 2, 4, 8 and 16?

Each stage corresponds to one bit of the binary shift amount.

```text
shift_amt[0] → 1
shift_amt[1] → 2
shift_amt[2] → 4
shift_amt[3] → 8
shift_amt[4] → 16
```

Combining these powers of two allows any shift from 0 to 31.

---

### 3. Why not simply use `data_in << shift_amt`?

The expression is functionally valid and a synthesis tool may infer appropriate hardware from it.

However, this challenge specifically focuses on understanding the **structural implementation** of a barrel shifter using explicit MUX stages.

Understanding the hardware structure is important when reasoning about:

- Logic depth.
- Timing.
- Area.
- Synthesis.
- Critical paths.

---

### 4. What is the main advantage of a barrel shifter?

It can perform an arbitrary shift in **one combinational operation**, rather than shifting one bit per clock cycle.

---

### 5. What is the main disadvantage?

A barrel shifter requires significantly more combinational hardware than a simple shift register because it contains multiple MUX stages.

---

### 6. What determines the critical-path depth?

The number of MUX stages determines the logical depth.

For a 32-bit barrel shifter:

```text
5 MUX levels
```

are required.

Therefore, the delay grows approximately with:

```text
O(log2 N)
```

rather than O(N).

---

### 7. What happens when `shift_amt = 0`?

All five stages select the **unchanged data path**.

Therefore:

```text
data_out = data_in
```

regardless of the direction.

---

### 8. What happens when `shift_amt = 31`?

All five stages are activated:

```text
1 + 2 + 4 + 8 + 16 = 31
```

The data is therefore shifted by the maximum supported amount.

---

### 9. What is the difference between logical and arithmetic right shift?

A logical right shift fills the newly created MSBs with zeros.

An arithmetic right shift replicates the sign bit to preserve the sign of a signed two's-complement number.

---

### 10. Why is no FSM required?

The barrel shifter is purely combinational.

There are no:

- States
- Clock cycles
- State transitions
- Stored values

The output is determined directly from the current inputs.

---

## Testbench Verification

The testbench was designed to verify:

- Zero shift.
- Left shift by 1.
- Left shift by multiple stages.
- Maximum left shift.
- Right shift by 1.
- Right shift by multiple stages.
- Maximum right shift.
- Multiple active MUX stages.
- Different input data patterns.

Example verification cases include:

```text
10 << 0  = 10
1  << 1  = 2
5  << 2  = 20
10 << 3  = 80
15 << 4  = 240

32  >> 1 = 16
64  >> 2 = 16
100 >> 3 = 12
255 >> 4 = 15

1024 << 5 = 32768
```

These cases verify both directions and demonstrate that multiple MUX stages can combine to produce the required shift amount.

---

## Key Learning

- Understood the architecture of a **32-bit barrel shifter**.
- Learned why a 32-bit barrel shifter requires **5 MUX stages**.
- Understood how binary shift amounts are decomposed into powers of two.
- Learned how each MUX stage performs an optional shift.
- Implemented logical left and right shifting.
- Understood why the design is purely combinational.
- Learned the difference between a barrel shifter and a shift register.
- Understood why barrel-shifter delay grows approximately as **O(log N)**.
- Learned how multiple stages combine to perform arbitrary shifts from 0 to 31.
- Understood the difference between logical and arithmetic right shifts.
- Learned how the same architecture can be extended to implement rotate operations.
- Verified the design using multiple simulation cases and waveform analysis.

---

## Simulation Result

✔ 32-bit logical left shifting verified.

✔ 32-bit logical right shifting verified.

✔ Shift amounts from 0 to 31 supported.

✔ All five MUX stages operate correctly.

✔ Multiple shift stages can be activated simultaneously.

✔ Maximum shift of 31 bits verified.

✔ Zero-fill behavior verified for logical shifts.

✔ Both left and right directions verified through simulation.

✔ Waveform confirms correct combinational operation.

✔ No clock or FSM is required.

✔ RTL structure demonstrates the intended **5-stage barrel-shifter architecture**.
