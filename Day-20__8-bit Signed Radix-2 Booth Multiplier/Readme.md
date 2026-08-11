# Day 20 — 8-bit Radix-2 Booth Multiplier (Signed)

## Question of the Day

### Problem Statement

Design a Verilog module that implements an 8-bit signed Radix-2 Booth Multiplier. Booth's algorithm performs signed multiplication using an accumulator, multiplier, previous multiplier bit, and repeated add/subtract and arithmetic shift operations.

### Module Declaration

```verilog
module top_module(
    input               clk,
    input               reset,
    input               start,
    input signed [7:0]  multiplicand,
    input signed [7:0]  multiplier,
    output signed [15:0] product,
    output              done
);
```

### Requirements

- Design an 8-bit × 8-bit signed Booth multiplier.
- Use Radix-2 Booth's algorithm.
- Initialize Q-1 to 0.
- Check `{Q[0], Q-1}` during every iteration.
  - `01` → add multiplicand to accumulator.
  - `10` → subtract multiplicand from accumulator.
  - `00` or `11` → no arithmetic operation.
- Perform an arithmetic right shift after every iteration.
- Perform exactly 8 iterations for an 8-bit multiplier.
- Keep the multiplicand constant throughout the multiplication.
- Generate a 16-bit signed product.
- Generate a `done` signal when the product is valid.
- Use synchronous active-high reset.

### My Approach

Designed the multiplier using a Finite State Machine (FSM) with IDLE, RUN, and DONE states.

When `start` is asserted, the multiplicand and multiplier are loaded into internal registers. The accumulator is initialized to zero and Q-1 is initialized to zero.

During the RUN state, the pair `{Q[0], Q-1}` is checked:

- `01` → A = A + M
- `10` → A = A - M
- `00` → No operation
- `11` → No operation

After the required arithmetic operation, the combined `{A, Q, Q-1}` register is arithmetically shifted right by one bit.

The process is repeated for 8 clock cycles. After the final iteration, the 16-bit product is generated and the FSM enters the DONE state.

### Key Learning

- Learned the basic working principle of Booth's signed multiplication algorithm.
- Understood the purpose of the accumulator (A), multiplicand (M), multiplier (Q), and Q-1 registers.
- Learned why `01` represents addition and `10` represents subtraction.
- Understood why `00` and `11` require no arithmetic operation.
- Learned why Q-1 is initialized to 0 for the first iteration.
- Understood why the multiplier's LSB becomes the new Q-1 after every shift.
- Learned the difference between a logical right shift and an arithmetic right shift.
- Understood the importance of sign extension for signed two's-complement arithmetic.
- Learned why the accumulator requires an additional bit for intermediate signed calculations.
- Implemented an FSM-based sequential multiplier with an iteration counter.
- Verified signed multiplication using positive and negative operands.

### Interview Concepts & Quick Revision

**What is Booth's Algorithm?**

Booth's algorithm is a method for performing signed binary multiplication using two's-complement numbers.

Instead of performing an addition for every 1 in the multiplier, Booth examines:

```
{Q[0], Q-1}
```

and decides whether to add, subtract, or do nothing.

**What is the role of M?**

M is the multiplicand.

It remains constant throughout all iterations.

```
M → constant
A → changes
Q → changes
Q-1 → changes
```

**What is the role of A?**

A is the accumulator.

It stores the intermediate result of the multiplication.

Depending on the Booth pair, it can perform:

```
A + M
A - M
A
```

**What is Q?**

Q contains the multiplier.

Its LSB, Q[0], is examined together with Q-1 to determine the Booth operation.

**What is Q-1?**

Q-1 stores the previous value of Q[0].

Initially:

```
Q-1 = 0
```

After every arithmetic right shift:

```
old Q[0] → new Q-1
```

**Why do we check two bits?**

Booth's algorithm examines:

```
{Q[0], Q-1}
```

The combinations determine the operation:

```
01 → +M
10 → -M
00 → Nothing
11 → Nothing
```

This allows Booth's algorithm to efficiently handle consecutive 1s in the multiplier.

**Why is the shift arithmetic?**

The operands are signed two's-complement numbers.

An arithmetic right shift preserves the sign bit.

For example:

Positive:

```
0100 >> 1 = 0010
```

Negative:

```
1100 >>> 1 = 1110
```

A logical shift would insert 0 at the MSB and could corrupt a negative value.

**Why does A need an extra bit?**

For an 8-bit signed number:

```
Range = -128 to +127
```

During Booth's intermediate calculations, values can temporarily exceed this range.

Therefore, the accumulator is extended to 9 bits to safely handle signed intermediate arithmetic.

**Why is M sign-extended?**

Suppose:

```
M = -5
```

8-bit representation:

```
11111011
```

When used with the 9-bit accumulator:

```
111111011
```

The sign bit `1` is extended so that the numerical value remains -5.

For positive values, `0` is extended instead.

**Why are there 8 iterations?**

The multiplier is:

```
8 bits
```

Therefore Booth's Radix-2 algorithm performs:

```
8 iterations
```

General rule:

```
Number of iterations = number of multiplier bits
```

**What is Radix-2 Booth?**

Radix-2 Booth processes one multiplier bit per iteration while examining the current bit and the previous bit.

For an 8-bit multiplier:

```
8 bits → 8 iterations
```

**What is Radix-4 Booth?**

Radix-4 Booth is an improved version that processes two multiplier bits per iteration by examining a three-bit group.

It can use operations such as:

```
0
+M
-M
+2M
-2M
```

Therefore, an 8-bit multiplication requires approximately:

```
4 iterations
```

instead of 8.

The tradeoff is increased hardware complexity.

**Why use Booth instead of normal shift-and-add?**

Normal shift-and-add may perform an addition for every 1 in the multiplier.

Booth can reduce unnecessary operations when the multiplier contains runs of consecutive 1s or 0s by representing transitions using addition and subtraction.

This can reduce the number of arithmetic operations.

**Why is this a sequential design?**

The multiplication is performed over multiple clock cycles.

Each clock cycle performs approximately:

```
Check → Add/Subtract → Shift → Count
```

Therefore, the design requires registers and sequential control.

**Why use an FSM?**

The FSM controls the different phases:

```
IDLE
  ↓ start
RUN
  ↓ 8 iterations
DONE
  ↓
IDLE
```

This makes the sequential multiplication process easier to control and understand.

### Simulation Result

- ✔ Successfully implemented an 8-bit signed Radix-2 Booth multiplier.
- ✔ Verified positive × positive multiplication.
- ✔ Verified positive × negative multiplication.
- ✔ Verified negative × positive multiplication.
- ✔ Verified negative × negative multiplication.
- ✔ Tested multiplication involving zero.
- ✔ Tested multiplication involving -1.
- ✔ Tested the most negative 8-bit value -128.
- ✔ Verified the arithmetic right-shift operation.
- ✔ Verified the 8-iteration Booth sequence.
- ✔ Verified that `done` indicates when the product becomes valid.
