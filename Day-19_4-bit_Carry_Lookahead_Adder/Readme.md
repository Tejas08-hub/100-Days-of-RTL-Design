# Day 19 — 4-bit Carry Lookahead Adder (CLA)

## Question of the Day

### Problem Statement

Design a **4-bit Carry Lookahead Adder (CLA)** using a structural Verilog approach.

### Module Declaration

```verilog
module top_module(
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
```

### Requirements

- Design a 4-bit Carry Lookahead Adder.
- Calculate Generate (G) and Propagate (P) signals for each bit.
- Use:
  - `G[i] = a[i] & b[i]`
  - `P[i] = a[i] ^ b[i]`
- Calculate carries directly using lookahead equations instead of chaining previous carries.
- Calculate the sum using `sum[i] = P[i] ^ C[i]`.
- The design must be purely combinational with no clock.
- Verify the design using multiple input combinations, including a case with carry propagation through the complete 4-bit adder.

### My Approach

Designed the CLA using Generate and Propagate signals.

For each bit:

```
Generate  = A & B
Propagate = A ^ B
```

The carry equations were expanded so that each carry can be calculated directly from the input Generate, Propagate, and cin signals.

The basic carry equation is:

```
Cout = G | (P & Cin)
```

For the 4-bit CLA, the intermediate carries were calculated using:

```
C1 = G0 | P0.Cin

C2 = G1 | P1.G0 | P1.P0.Cin

C3 = G2 | P2.G1 | P2.P1.G0 | P2.P1.P0.Cin
```

The final carry-out was also calculated directly using the complete lookahead equation.

The sum bits were then generated using:

```
Sum[i] = P[i] ^ C[i]
```

This avoids waiting for the carry to ripple from one bit to the next.

### Key Learning

- Learned why a Ripple-Carry Adder becomes slower as the bit-width increases.
- Understood that the carry chain can become the critical timing path.
- Learned the concepts of Generate and Propagate.
- Implemented:
  - `G = A & B`
  - `P = A ^ B`
- Understood how carry lookahead equations eliminate the serial carry dependency.
- Learned that CLA improves speed at the cost of additional combinational hardware.
- Understood why large adders use hierarchical/block CLA structures instead of one large flat CLA.
- Connected the CLA critical path to the STA concepts studied in Day 6.
- Verified the design using multiple input combinations and carry propagation cases.

### Interview Questions & Answers

**1. What is the main problem with a Ripple-Carry Adder?**

Each carry depends on the previous carry:

```
C0 → C1 → C2 → C3 → Cout
```

Therefore, the carry must propagate through every bit, increasing the critical path delay.

**2. What is Generate?**

Generate means that a bit produces a carry by itself.

```
G = A & B
```

When A = 1 and B = 1, a carry is generated regardless of Cin.

**3. What is Propagate?**

Propagate means that a bit allows an incoming carry to pass to the next bit.

```
P = A ^ B
```

When exactly one of A or B is 1, an incoming carry can propagate through that bit.

**4. What is the basic carry equation?**

```
Cout = G | (P & Cin)
```

A carry is produced either because the bit generates one or because it propagates the incoming carry.

**5. Why is CLA faster than Ripple-Carry?**

A Ripple-Carry Adder waits for each previous carry, while a CLA calculates carries directly using Generate and Propagate signals.

Therefore, the serial carry dependency is reduced.

**6. What is the trade-off in using a CLA?**

CLA provides faster carry calculation but requires more combinational logic.

> Higher Speed ↔ More Hardware

**7. Why don't we build a flat 64-bit CLA?**

The lookahead equations become very large and require large fan-in logic.

Therefore, practical designs use hierarchical or block-based CLA structures.

**8. Why not simply write `a + b + cin`?**

A synthesis tool can generate an optimized adder from the arithmetic expression, but this challenge tests understanding of the internal CLA architecture, Generate/Propagate logic, carry equations, and timing trade-offs.

### Simulation Result

- ✔ Generate and Propagate signals verified.
- ✔ Carry lookahead equations verified.
- ✔ Sum and carry-out values match the expected arithmetic results.
- ✔ Complete carry propagation case successfully tested.
- ✔ Multiple input combinations verified through simulation.
- ✔ Purely combinational operation confirmed.
- ✔ No clock or sequential logic used.
- ✔ Simulation waveform confirms correct 4-bit CLA operation.
