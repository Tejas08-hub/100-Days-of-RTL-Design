# Day 11 — Simple Traffic Light Controller (Fixed Timing)

## Question of the Day

### Problem Statement

Write a Verilog module that implements a **Simple Traffic Light Controller** using a **Finite State Machine (FSM)**.

### Module Declaration

```verilog
module top_module(
    input        clk,
    input        reset,     // synchronous, active high
    output reg [1:0] light   // 2'b00 = Red, 2'b01 = Green, 2'b10 = Yellow
);
```

### Requirements

- Design a simple **Traffic Light Controller** using an FSM.
- The traffic light should continuously cycle in the following order:
  - **Green** → 4 clock cycles
  - **Yellow** → 2 clock cycles
  - **Red** → 4 clock cycles
  - Repeat continuously.
- Use a **synchronous active-high reset**, which initializes the controller to the **Red** state.
- Use a **counter** to keep track of the number of clock cycles spent in each state.
- Implement the state transition logic using a **case** statement.
- Update the FSM on the **rising edge** of the clock.
- Use **non-blocking assignments (`<=`)** for sequential logic.

---

## My Approach

Designed the traffic light controller as a **Moore Finite State Machine (FSM)** with **three states**, where each state represents one traffic light color.

The implemented states are:

- **RED** – Traffic light remains Red for **4 clock cycles**.
- **GREEN** – Traffic light remains Green for **4 clock cycles**.
- **YELLOW** – Traffic light remains Yellow for **2 clock cycles**.

A **2-bit counter** is used to count the number of clock cycles spent in the current state. The controller checks whether the required duration for the current state has been completed. If not, the counter increments and the FSM remains in the same state. Once the required number of clock cycles is reached, the counter resets to zero and the FSM transitions to the next state.

The output `light` depends only on the current FSM state, making the controller a **Moore FSM**.

---

## Key Learning

- Understood how to design a **time-based Moore FSM**.
- Learned how to combine a **state register** and a **counter** to implement fixed timing behavior.
- Understood why the counter must be reset whenever the FSM changes to a new state.
- Learned to separate **state transition logic** from **output logic**, improving RTL readability and scalability.
- Implemented synchronous reset using **non-blocking assignments (`<=`)**.
- Verified the complete traffic light sequence using simulation waveforms.

---

## Interview Concepts

- **Why reset the counter when changing states?**

  The counter measures how long the controller stays in the current state. If it is not reset during a state transition, the next state would inherit the previous count value, causing incorrect timing and premature state transitions.

- **How can the timing values be made configurable?**

  Instead of hardcoding the values (4, 2, 4), they can be defined as **Verilog parameters**, allowing the traffic light timings to be easily modified without changing the FSM logic.

- **What real-world concept does this relate to?**

  Real traffic controllers manage multiple directions (North-South and East-West) and must ensure conflicting directions are never green simultaneously. This follows the principle of **mutual exclusion**, which is conceptually similar to the **Round Robin Arbiter (Day 08)**, where only one requester is granted access at a time.

---

## Simulation Result

✔ FSM cycles through **Green → Yellow → Red** repeatedly.

✔ Green remains active for **4 clock cycles**.

✔ Yellow remains active for **2 clock cycles**.

✔ Red remains active for **4 clock cycles**.

✔ Counter resets correctly during every state transition.

✔ Synchronous reset initializes the controller to the **Red** state.

✔ State transitions and output behavior verified using simulation waveforms.
