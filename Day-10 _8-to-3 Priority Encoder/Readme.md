# Day 10 — 8-to-3 Priority Encoder

## Question of the Day

### Problem Statement

Write a Verilog module that implements an **8-to-3 Priority Encoder**.

### Module Declaration

```verilog
module top_module(
    input  [7:0] in,
    output reg [2:0] pos,
    output           valid
);
```

### Requirements

- Design an **8-to-3 Priority Encoder**.
- `in[7]` has the **highest priority**, while `in[0]` has the **lowest priority**.
- If multiple input bits are high simultaneously, the encoder must output the position of the **highest-priority** asserted bit.
- The output `pos` should represent the index of the highest asserted input bit.
- The output `valid` should be **1** whenever at least one input bit is high.
- If all input bits are low (`in == 8'b00000000`), `valid` should be **0** and `pos` is treated as don't care.
- Implement the priority logic using a **casez** statement with **?** wildcards.

---

## My Approach

Designed the priority encoder using a **combinational `casez` statement**, where each case item represents the highest-priority input bit.

The priority is assigned as follows:

- **in[7]** → Highest Priority
- **in[6]**
- **in[5]**
- **in[4]**
- **in[3]**
- **in[2]**
- **in[1]**
- **in[0]** → Lowest Priority

The `casez` statement checks the input from **MSB to LSB**, ensuring that whenever multiple inputs are high, the encoder always selects the **highest-priority bit**.

The output `pos` stores the binary index of the highest asserted input, while `valid` is asserted whenever any input bit is high.

---

## Why `casez`?

A **Priority Encoder** requires checking inputs from the **highest priority to the lowest priority**.

Using `casez` with **?** wildcards allows lower-priority bits to be treated as **don't-care**, making the code simple, readable, and easy to maintain.

For example,

```verilog
8'b1???????: pos = 3'b111;
```

matches **every input** where `in[7] = 1`, regardless of the values of the remaining bits.

Similarly,

```verilog
8'b01??????: pos = 3'b110;
```

matches whenever `in[7] = 0` and `in[6] = 1`.

Compared to a long chain of nested `if-else` statements, `casez` provides a cleaner and more scalable implementation. It is also the commonly preferred coding style for priority logic in interviews and RTL design.

---

## Key Learning

- Understood the working principle of a **Priority Encoder**.
- Learned how priority is assigned among multiple active inputs.
- Learned to implement priority logic using the **`casez`** statement.
- Understood the purpose of **? wildcards** for representing don't-care bits.
- Learned the difference between **`casez`** and **`casex`**, and why `casez` is generally preferred in RTL design.
- Understood how the `valid` signal indicates whether any input bit is asserted.
- Verified priority encoding behavior using simulation.

---

## Simulation Result

✔ Correctly identifies the highest-priority asserted input.

✔ Outputs the correct binary position of the highest asserted bit.

✔ `valid` is asserted whenever at least one input bit is high.

✔ When all inputs are low, `valid` becomes **0**.

✔ Verified correct functionality for single-bit, multiple-bit, and all-zero input combinations through simulation.
