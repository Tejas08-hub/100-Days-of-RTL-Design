# Day 23 — Switch Debounce Circuit

## Question of the Day

### Problem Statement

Design a Verilog module that implements a **switch debouncer** for a mechanical push button.

Mechanical switches do not produce a perfectly clean digital transition. When a button is pressed or released, the physical contacts can rapidly make and break contact for several milliseconds before settling.

For example, instead of:

```text
0 ─────────────────── 1
```

a real switch may produce:

```text
0 ───── 1 ─ 0 ─ 1 ─ 0 ───── 1
          Bouncing
```

If this raw signal is connected directly to digital logic such as a counter or FSM, one physical button press may be interpreted as multiple button presses.

The solution is to first synchronize the asynchronous switch input and then require the synchronized signal to remain stable for a fixed number of clock cycles before accepting the new value.

### Module Declaration

```verilog
module top_module #(
    parameter CLK_FREQ    = 50_000_000,
    parameter DEBOUNCE_MS = 10
)(
    input clk,
    input reset,
    input switch_in,
    output reg switch_out
);
```

---

## Requirements

- Design a switch debouncer using Verilog RTL.
- Use a **2-flop synchronizer** for the asynchronous mechanical switch input.
- Calculate the debounce interval using:

```text
DEBOUNCE_CYCLES = CLK_FREQ × DEBOUNCE_MS / 1000
```

- Require the synchronized switch input to remain stable for the complete debounce window.
- Increment the stability counter while the synchronized input remains different from the current debounced output.
- Reset the stability counter if the candidate input returns to the current debounced value.
- Update `switch_out` only after the input has remained stable for the required number of cycles.
- Use a synchronous active-high reset.
- For simulation, use smaller parameter values so that the debounce process can be observed easily.

---

## My Approach

The design was divided into two main stages:

1. **Input Synchronization**
2. **Switch Debouncing**

The mechanical switch is asynchronous to the FPGA clock, so the raw `switch_in` signal is first passed through a 2-flop synchronizer.

```text
switch_in
    ↓
sync_1
    ↓
sync_2
```

The synchronized signal `sync_2` is then used by the debounce logic.

The debounce circuit compares the synchronized input with the current `switch_out`.

If both values are equal, there is no pending change and the counter is reset to zero.

If they are different, the counter starts counting consecutive stable clock cycles.

Once the counter reaches the required debounce period, the new value is accepted:

```text
sync_2 ≠ switch_out
        ↓
   start counting
        ↓
 stable for N cycles?
        ↓
       YES
        ↓
switch_out <= sync_2
```

---

## Design Architecture

```text
              Mechanical Switch
                     │
                     ▼
                 switch_in
                     │
                     │ Asynchronous
                     ▼
                ┌─────────┐
                │  Sync_1 │
                └────┬────┘
                     │
                     ▼
                ┌─────────┐
                │  Sync_2 │
                └────┬────┘
                     │
                     ▼
             Synchronized Input
                     │
                     ▼
              ┌─────────────┐
              │  Compare    │
              │ sync_2 with │
              │ switch_out  │
              └──────┬──────┘
                     │
              Different?
               /                        NO             YES
             │               │
             ▼               ▼
       Counter = 0       Counter++
                             │
                             ▼
                    Stable for N cycles?
                         /                              NO         YES
                       │           │
                       ▼           ▼
                    Continue   Accept value
                                  │
                                  ▼
                             switch_out
```

---

## Why Does a Mechanical Switch Bounce?

A mechanical switch contains physical metal contacts.

When the button is pressed, the contacts do not necessarily come together and remain perfectly connected immediately.

Because of mechanical movement, elasticity, vibration, and the physical properties of the contacts, they can repeatedly make and break contact for a short period.

Therefore, a single physical press can electrically look like:

```text
0 → 1 → 0 → 1 → 0 → 1
```

before finally settling at:

```text
1
```

Similarly, releasing the button can produce:

```text
1 → 0 → 1 → 0 → 1 → 0
```

This behavior is called **switch bounce**.

---

## Why Does Switch Bounce Cause a Digital Problem?

Digital logic interprets voltage levels as binary values.

Therefore, the FPGA may interpret:

```text
0 → 1 → 0 → 1 → 0 → 1
```

as multiple separate events.

For example, if a button is connected directly to a counter:

```text
One physical press
        ↓
0 → 1 → 0 → 1 → 0 → 1
        ↓
Counter may increment multiple times
```

But the desired behavior is:

```text
One physical press
        ↓
One clean transition
        ↓
Counter increments once
```

The debouncer prevents these unwanted transitions from reaching the rest of the digital system.

---

## 2-Flop Synchronizer

The mechanical switch is not synchronized to the FPGA clock.

Therefore, `switch_in` can change close to a clock edge and potentially violate the setup or hold time of the first receiving flip-flop.

This can cause metastability.

To reduce the probability of metastability propagating into the rest of the design, a 2-flop synchronizer is used:

```text
switch_in
    │
    ▼
  Sync_1
    │
    ▼
  Sync_2
    │
    ▼
Debounce Logic
```

The first flip-flop may enter metastability.

The second flip-flop provides additional time for the first stage to resolve before the signal is used by the debounce logic.

Therefore, the debounce circuit operates on `sync_2` rather than directly on `switch_in`.

---

## Synchronization vs Debouncing

These two operations solve **different problems**.

### Synchronization

Purpose:

```text
Asynchronous input
       ↓
Reduce metastability risk
```

Implemented using:

```text
switch_in → sync_1 → sync_2
```

### Debouncing

Purpose:

```text
Mechanical bouncing
       ↓
Require stable input for N cycles
```

Implemented using:

```text
sync_2 → stability counter → switch_out
```

Therefore:

> **The synchronizer handles the asynchronous nature of the input, while the debounce logic handles the mechanical bouncing.**

Both are important when interfacing a mechanical switch with synchronous digital logic.

---

## Debounce Counter Operation

The counter measures:

> **The number of consecutive clock cycles for which the synchronized input remains different from the current debounced output.**

Suppose:

```text
DEBOUNCE_CYCLES = 5
switch_out = 0
```

and the synchronized input becomes:

```text
sync_2:

Cycle:     1  2  3  4  5
           1  1  1  1  1
```

With the RTL implementation using:

```verilog
counter == DEBOUNCE_CYCLES - 1
```

the counter register reaches `4` for a 5-cycle window before the new value is accepted.

```text
Counter:

0 → 1 → 2 → 3 → 4 → 0
                    ↑
                Accept
```

After acceptance:

```text
switch_out <= sync_2;
counter <= 0;
```

---

## What Happens During Bounce?

Suppose:

```text
switch_out = 0
```

and the synchronized input behaves like:

```text
sync_2:

1 1 1 0 1 1 1 1 1
      ↑
    bounce
```

The counter begins counting:

```text
1 → 2 → 3
```

But when the input returns to `0`, it becomes equal to `switch_out`.

Therefore:

```text
counter = 0
```

The previous partial stability period is discarded.

When the input becomes `1` again, counting starts from the beginning.

This ensures that a near-miss does not cause the switch to be accepted.

---

## Stability Is More Important Than Total Time

The debounce counter does not measure:

```text
Total time the input has been 1
```

It measures:

```text
Continuous time the input has remained stable
```

For example:

```text
Cycle:      1  2  3  4  5  6  7
sync_2:     1  1  1  0  1  1  1
counter:    1  2  3  0  1  2  3
```

The `0` at cycle 4 breaks the stability period.

Therefore, the counter resets.

---

## Why Doesn't `switch_out` Follow `sync_2` Immediately?

The synchronized input is treated as a **candidate value**.

The debounced output is the **confirmed value**.

The design waits for the candidate value to remain stable for the complete debounce window before updating `switch_out`.

Therefore:

```text
sync_2:      0 ──── 1 ─────────────
                   ↑
               changes early

switch_out:  0 ─────────── 1 ─────
                         ↑
                  accepted later
```

This delay is intentional.

---

## Why Not Simply Use an RC Filter?

An RC filter is a possible hardware solution for switch debouncing.

An RC circuit smooths the rapid voltage transitions produced by mechanical bounce.

However, a digital debounce circuit provides several advantages:

- Debounce time can be controlled digitally.
- The behavior is deterministic in clock cycles.
- The same RTL design can be reused across different systems.
- The debounce interval can be changed using parameters.
- The synchronized signal can be processed directly inside the FPGA.

An RC filter can still be useful in hardware, especially when combined with a suitable input buffer or Schmitt trigger.

Therefore:

```text
RC Filter → Analog/hardware filtering

Digital Debouncer → Clock-based digital filtering
```

They solve the same general problem using different approaches.

---

## Choosing the Debounce Window

The debounce window must be chosen carefully.

### If the window is too short

The switch may still be bouncing when the circuit accepts the new value.

This can result in:

- Multiple detected presses
- False transitions
- Unstable output

Example:

```text
Bounce duration = 8 ms
Debounce window = 2 ms
```

The circuit may accept the signal before the contacts have settled.

### If the window is too long

The switch will respond slowly.

For example:

```text
Physical press
     ↓
Wait 100 ms
     ↓
switch_out changes
```

The button may feel unresponsive.

Therefore, the debounce period should be long enough to filter the expected bounce but short enough to provide acceptable response time.

---

## Calculating the Debounce Counter

The required number of clock cycles is:

```text
DEBOUNCE_CYCLES =
(CLK_FREQ × DEBOUNCE_MS) / 1000
```

For:

```text
CLK_FREQ = 50 MHz
DEBOUNCE_MS = 10 ms
```

we get:

```text
50,000,000 × 10 / 1000
= 500,000 cycles
```

Therefore, the counter needs to count approximately 500,000 clock cycles.

---

## Simulation Scaling

A real FPGA design may use:

```text
CLK_FREQ = 50 MHz
DEBOUNCE_MS = 10
```

which requires:

```text
500,000 clock cycles
```

That would make simulation unnecessarily long.

Therefore, the simulation uses smaller parameter values.

For example:

```verilog
top_module #(
    .CLK_FREQ(1000),
    .DEBOUNCE_MS(5)
)
```

This gives:

```text
1000 × 5 / 1000 = 5 cycles
```

The same debounce principle is preserved while making the waveform easy to observe.

---

## Testbench Strategy

The testbench intentionally models realistic switch bounce rather than applying only clean transitions.

For example:

```text
switch_in:

0 ─── 1 ─ 0 ─ 1 ─ 0 ─ 1 ───────────── 1
        Bouncing              Stable
```

The testbench also models bouncing during switch release:

```text
1 ─── 0 ─ 1 ─ 0 ─ 1 ───────────── 0
        Bouncing              Stable
```

The expected behavior is:

```text
switch_in
    ↓
rapid transitions
    ↓
switch_out remains unchanged
    ↓
input becomes stable
    ↓
debounce counter reaches limit
    ↓
switch_out changes
```

---

## Simulation Result

The design was verified using a reduced simulation debounce interval.

The waveform demonstrated:

✔ Raw `switch_in` contains multiple bouncing transitions.

✔ `sync_1` and `sync_2` synchronize the asynchronous input.

✔ The debounce counter resets when the candidate input returns to the current debounced value.

✔ The counter only accumulates during a continuous stable period.

✔ `switch_out` does not respond immediately to bouncing.

✔ `switch_out` changes only after the required stability period.

✔ Both switch press and release operations are debounced.

✔ A short bounce does not create multiple output transitions.

✔ The counter reaches the required terminal count and then resets after accepting the new value.

---

## Interview Concepts & Quick Revision

### Why does a mechanical switch bounce?

Mechanical contacts physically make and break contact several times due to mechanical movement, elasticity, vibration, and contact interaction before settling into a stable state.

### Why can't we directly use `switch_in`?

The switch is asynchronous to the FPGA clock and may cause metastability if sampled directly.

Therefore:

```text
switch_in → sync_1 → sync_2
```

is used before the debounce logic.

### What does the synchronizer solve?

The 2-flop synchronizer reduces the probability that metastability from the asynchronous input propagates into the rest of the synchronous logic.

### What does the debounce counter solve?

The counter filters out rapid transitions caused by mechanical bouncing.

It requires the synchronized input to remain stable for a predetermined number of clock cycles.

### What happens if the input changes during the debounce period?

The stability counter resets.

For example:

```text
1 1 1 0
      ↑
    change
```

The previous count is discarded.

### Why compare `sync_2` with `switch_out`?

`switch_out` represents the currently accepted stable state.

If:

```text
sync_2 == switch_out
```

there is no pending transition.

If:

```text
sync_2 != switch_out
```

a possible new switch state is being detected and the stability counter starts.

### Why doesn't the counter simply count continuously?

Because it must measure **continuous stability**.

If the input changes during the debounce window, the previous stability period is no longer valid and the counter must reset.

### What happens if the debounce window is too short?

The circuit may accept a bouncing signal before the mechanical contacts settle.

This can result in false or multiple transitions.

### What happens if the debounce window is too long?

The button response becomes slower because the circuit waits too long before accepting a valid transition.

### Can an RC filter be used instead?

Yes.

An RC filter is a hardware-based solution that smooths rapid voltage transitions.

A digital debounce circuit performs filtering using clocked digital logic.

In practical systems, both analog filtering and digital debouncing may be used depending on the application.

### Is synchronization the same as debouncing?

No.

They solve different problems:

```text
Synchronization → Metastability protection

Debouncing → Mechanical bounce filtering
```

A robust FPGA button interface generally needs both.

### Why is `switch_out` a registered signal?

The debounced output is generated synchronously with the FPGA clock.

This makes the output stable and predictable for other synchronous logic such as:

- Counters
- FSMs
- Registers
- Control logic

---

## Key Learning

- Learned how mechanical switches produce multiple transitions due to contact bounce.
- Understood why one physical button press can be interpreted as multiple digital events.
- Learned why raw mechanical inputs are asynchronous to FPGA clock domains.
- Reviewed the use of a 2-flop synchronizer for asynchronous inputs.
- Understood the difference between **metastability protection** and **debouncing**.
- Designed a stability counter-based debounce mechanism.
- Learned that the counter measures consecutive stable clock cycles.
- Learned why the counter must reset whenever the candidate input changes.
- Understood why `switch_out` should not immediately follow the synchronized input.
- Learned how to calculate the debounce interval from clock frequency and debounce time.
- Used parameterized debounce timing.
- Scaled the parameters down for faster simulation.
- Verified both button press and button release behavior.
- Observed the complete synchronization and debounce process in simulation.

---

## Conclusion

This project demonstrates a **Switch Debounce Circuit** for interfacing a real-world mechanical input with synchronous digital logic.

A mechanical switch can generate multiple unwanted transitions during pressing or releasing because of contact bounce. Since the switch is also asynchronous to the FPGA clock, the input should first pass through a 2-flop synchronizer.

The synchronized signal is then monitored using a stability counter. The counter only increments while the candidate value remains different from the current debounced output. If the candidate changes back during the debounce period, the counter resets.

Once the candidate value remains stable for the complete debounce window, the new value is accepted and `switch_out` changes.

The complete concept is:

```text
Mechanical Switch
       ↓
Asynchronous Input
       ↓
2-Flop Synchronizer
       ↓
Synchronized Input
       ↓
Stability Counter
       ↓
Stable for N Clock Cycles
       ↓
Debounced Output
```

This technique is widely applicable to FPGA and digital systems that interface with mechanical push buttons, switches, and other slow asynchronous control inputs.
