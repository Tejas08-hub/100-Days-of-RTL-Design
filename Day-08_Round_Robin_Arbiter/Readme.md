# Day 08 — Round Robin Arbiter (4 Requesters)

## Question of the Day

### Problem Statement

Write a Verilog module that implements a **4-requester Round Robin Arbiter**. The arbiter grants access to a shared resource while ensuring that only one requester is served at a time and that all requesters receive fair access over time.

### Module Declaration

```verilog
module top_module(
    input        clk,
    input        reset,     // synchronous, active high
    input  [3:0] req,       // one bit per requester, 1 = requesting
    output reg [3:0] grant   // one-hot: at most one bit set per cycle
);
```

### Requirements

- Design a 4-requester Round Robin Arbiter.
- Only one requester can be granted access during a clock cycle (one-hot output).
- If no requester is active (`req = 4'b0000`), the grant output must remain `4'b0000`.
- After granting requester **i**, the next arbitration must begin from requester **i+1** (wrapping around after requester 3).
- Skip inactive requesters while searching for the next requester.
- Use a synchronous active-high reset.
- Update the design on the rising edge of the clock.
- Implement the design using non-blocking assignments (`<=`).

---

## My Approach

Designed the arbiter as a **Finite State Machine (FSM)** where each state represents the **last requester that received the grant**.

The implemented states are:

- **NO_WIN** – Initial state after reset.
- **REQ_ZERO** – Requester 0 was the previous winner.
- **REQ_ONE** – Requester 1 was the previous winner.
- **REQ_TWO** – Requester 2 was the previous winner.
- **REQ_THREE** – Requester 3 was the previous winner.

Instead of always starting the arbitration from Requester 0, the FSM begins searching from the requester immediately after the previous winner. The search wraps around in a circular manner until an active requester is found.

This rotating priority mechanism guarantees fairness while ensuring that only one requester is granted access in every clock cycle.

---

## Key Learning

- Learned the difference between **Fixed Priority Arbitration** and **Round Robin Arbitration**.
- Understood how **Round Robin prevents starvation** by rotating priorities.
- Learned that the arbiter must remember the **previous winner**, making the design sequential rather than purely combinational.
- Implemented **one-hot grant generation**, ensuring only one requester accesses the shared resource at any time.
- Learned how arbitration scans requesters in a **circular order** instead of always starting from Requester 0.
- Designed the complete arbiter using a **Finite State Machine (FSM)**.
- Verified arbitration fairness through simulation.

---

## Interview Concepts & Quick Revision

### Why Round Robin instead of Fixed Priority?

A Fixed Priority Arbiter always gives preference to the highest-priority requester. If that requester continuously requests the resource, lower-priority requesters may never receive service. This problem is called **starvation**.

Round Robin rotates the priority after every successful grant, ensuring that every active requester eventually receives access to the shared resource.

---

### Why must the grant output be one-hot?

Only one requester should access the shared resource during a clock cycle.

If two grant signals become active simultaneously:

- Bus contention occurs.
- Multiple devices drive the shared bus.
- Data corruption may occur.
- System functionality becomes unreliable.

Therefore, the grant output must always be **one-hot**.

Example:

```
Valid Grants

0001
0010
0100
1000
```

Invalid:

```
0011
1100
1111
```

---

### Why is this a Sequential Circuit?

Round Robin arbitration depends on the **previous winner**.

The arbiter must remember which requester was granted last so that the next arbitration begins from the following requester.

Since remembering previous information requires storage, the design uses **flip-flops (registers)** and is implemented as a **Finite State Machine (FSM)**.

---

### How does Round Robin prevent starvation?

After each successful grant, the priority rotates.

Example:

```
Previous Winner = Requester 1

Searching Order

Requester 2
↓
Requester 3
↓
Requester 0
↓
Requester 1
```

Every requester eventually becomes the highest-priority requester.

---

### What happens when no requester is active?

If:

```
req = 0000
```

Then:

- No requester receives a grant.
- `grant = 0000`
- The arbiter remembers the previous winner so that arbitration resumes correctly when a new request arrives.

---

### What if only one requester continuously requests?

If only one requester remains active, it continues receiving the grant every clock cycle because there are no competing requests.

Example:

```
req = 0001

Cycle 1 → 0001
Cycle 2 → 0001
Cycle 3 → 0001
```

---

### What if multiple requesters continuously request?

The arbiter rotates fairly among all active requesters.

Example:

```
req = 0101

Cycle 1 → Requester 0
Cycle 2 → Requester 2
Cycle 3 → Requester 0
Cycle 4 → Requester 2
```

---

### What happens if request signals come from another clock domain?

Asynchronous request signals may cause:

- Metastability
- Incorrect arbitration
- Unreliable grant generation

Such signals should first be synchronized using **two-flop synchronizers**, similar to the CDC Synchronizer implemented earlier.

---

### How can this design be extended?

The same arbitration algorithm can be extended to:

- 8-requester arbiters
- 16-requester arbiters
- Weighted Round Robin
- Hierarchical arbiters used in modern SoCs

The overall arbitration principle remains the same.

---

## Simulation Result

✔ Successfully grants only one requester per clock cycle.

✔ One-hot grant generation verified.

✔ Fair Round Robin arbitration verified.

✔ Correct priority rotation after every successful grant.

✔ Correctly handles multiple simultaneous requests.

✔ No grant generated when no requester is active.

✔ FSM transitions and arbitration behavior verified using simulation waveforms.

---

## Conclusion

This project demonstrates the implementation of a **4-requester Round Robin Arbiter** using a **Finite State Machine (FSM)**. The design ensures fair resource allocation, prevents starvation through rotating priority, and guarantees safe shared-resource access by generating one-hot grant outputs. This is a fundamental arbitration technique widely used in buses, Network-on-Chip (NoC) architectures, memory controllers, and modern System-on-Chip (SoC) designs.
