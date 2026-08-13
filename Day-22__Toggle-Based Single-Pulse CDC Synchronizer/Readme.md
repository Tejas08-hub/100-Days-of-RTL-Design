# Day 22 — Toggle-Based Single-Pulse CDC Synchronizer

## Question of the Day

### Problem Statement

Design a Verilog module that safely transfers a **single-cycle pulse from a source clock domain to a destination clock domain** using a **toggle-based Clock Domain Crossing (CDC) synchronizer**.

A simple 2-flop synchronizer is suitable for synchronizing level signals, but a short pulse can be completely missed when the source clock is faster than the destination clock.

The solution is to convert the source pulse into a **toggle**, synchronize the toggle using a 2-flop synchronizer in the destination domain, and then detect the toggle transition using an XOR operation to regenerate a clean one-cycle pulse in the destination domain.

### Module Declaration

```verilog
module top_module(
    input  clk_src,     // source domain clock
    input  rst_src,     // source domain synchronous reset
    input  pulse_in,    // single-cycle pulse in source domain

    input  clk_dst,     // destination domain clock
    input  rst_dst,     // destination domain synchronous reset
    output pulse_out    // single-cycle pulse in destination domain
);
```

### Requirements

- Transfer a single-cycle pulse from the source clock domain to the destination clock domain.
- Use a toggle flip-flop in the source domain.
- Toggle the state whenever `pulse_in` is asserted.
- Synchronize the toggle signal using a 2-flop synchronizer in the destination domain.
- Use a delayed copy of the synchronized toggle.
- Generate `pulse_out` using XOR between the current and delayed synchronized toggle.
- `pulse_out` must be exactly one destination-clock cycle wide.
- Use separate synchronous resets for the source and destination clock domains.
- Do not directly synchronize the short `pulse_in` signal.
- The source pulses must be sufficiently spaced so that each toggle can propagate through the destination synchronizer before another toggle occurs.

---

## My Approach

A direct 2-flop synchronizer cannot reliably transfer a short pulse between asynchronous clock domains.

If the source clock is faster than the destination clock, the entire source pulse can occur between two destination clock edges.

For example:

```
clk_dst:
____|‾|________________|‾|____

pulse_in:
_______|‾‾|___________________
```

The destination may never sample the pulse while it is high.

Therefore, instead of transferring the pulse directly, I converted the pulse into a toggle signal.

The source-domain toggle changes state whenever a pulse arrives:

- Pulse 1 → 0 → 1
- Pulse 2 → 1 → 0
- Pulse 3 → 0 → 1

The toggle remains in its new state until the next pulse arrives, giving the destination clock enough time to observe the state change.

The toggle is then passed through a 2-flop synchronizer:

```
toggle → sync_1 → sync_2
```

Finally, a delayed copy of `sync_2` is maintained:

```
sync_2 → sync_d
```

The output pulse is generated using:

```verilog
pulse_out = sync_2 ^ sync_d;
```

The XOR detects both rising and falling transitions of the synchronized toggle.

---

## Design Architecture

```
                 SOURCE DOMAIN
                 
pulse_in
   │
   ▼
┌──────────┐
│ Toggle FF│
└────┬─────┘
     │
     │ Toggle Signal
     │
═════╪════════════════════ CDC Boundary
     │
     ▼
┌──────────┐
│  Sync_1  │
└────┬─────┘
     │
     ▼
┌──────────┐
│  Sync_2  │
└────┬─────┘
     │
     ├──────────────┐
     │              │
     ▼              ▼
  Current        Delayed
   Toggle         Toggle
     │              │
     └──────┬───────┘
            ▼
           XOR
            │
            ▼
        pulse_out
```

---

## How the Toggle Works

Initially:

```
toggle = 0
```

When the first pulse arrives:

```
pulse_in = 1
```

the toggle changes:

```
0 → 1
```

When the second pulse arrives:

```
1 → 0
```

The third pulse changes it again:

```
0 → 1
```

Therefore:

| Pulse   | Toggle |
|---------|--------|
| None    | 0      |
| Pulse 1 | 1      |
| Pulse 2 | 0      |
| Pulse 3 | 1      |
| Pulse 4 | 0      |

The pulse itself may be very short, but the toggle state remains changed until the next event.

---

## 2-Flop Synchronization

The toggle signal is asynchronous with respect to `clk_dst`.

Therefore, it must not directly drive destination-domain logic.

A 2-flop synchronizer is used:

```
toggle
   │
   ▼
sync_1
   │
   ▼
sync_2
```

The first flip-flop may experience metastability.

The second flip-flop provides additional time for the metastability to resolve before the signal is used by destination-domain logic.

The destination logic therefore uses `sync_2`.

---

## XOR Pulse Generation

A delayed copy of the synchronized toggle is maintained:

```
sync_2
   │
   ▼
sync_d
```

Then:

```verilog
pulse_out = sync_2 ^ sync_d;
```

XOR produces 1 whenever the two values are different.

**No Toggle Change**
```
sync_2 = 0
sync_d = 0

0 ^ 0 = 0
```
No pulse.

Similarly:
```
sync_2 = 1
sync_d = 1

1 ^ 1 = 0
```
No pulse.

**Toggle Changes 0 → 1**
```
sync_2 = 1
sync_d = 0

1 ^ 0 = 1
```
A destination pulse is generated.

**Toggle Changes 1 → 0**
```
sync_2 = 0
sync_d = 1

0 ^ 1 = 1
```
A destination pulse is also generated.

Therefore, both toggle transitions represent valid events:

```
0 → 1 = Event
1 → 0 = Event
```

---

## Example Timing

Consider:

```
clk_src = 100 MHz
clk_dst = 25 MHz
```

Therefore:

```
Tsrc = 10 ns
Tdst = 40 ns
```

A source pulse may last only:

```
10 ns
```

while the destination clock period is:

```
40 ns
```

The destination may completely miss the original pulse.

However, the toggle remembers the event:

```
pulse_in
    ↓
toggle: 0 → 1
```

The destination eventually receives:

```
sync_1: 0 → 1
sync_2: 0 → 1
```

Then the XOR detects the change:

```
sync_2 = 1
sync_d = 0

1 ^ 0 = 1
```

and produces:

```
pulse_out = 1
```

for one destination-clock cycle.

On the following cycle:

```
sync_2 = 1
sync_d = 1

1 ^ 1 = 0
```

Therefore:

```
pulse_out:

________|‾‾‾‾|________
         1 clk_dst
```

---

## Why Does pulse_out Appear Later Than pulse_in?

The destination pulse is not expected to occur at the same time as the source pulse.

The event must first pass through:

```
pulse_in
   ↓
toggle
   ↓
sync_1
   ↓
sync_2
   ↓
sync_d / XOR
   ↓
pulse_out
```

Therefore, a few destination clock cycles of latency are expected.

The important requirement is not zero latency.

The important requirement is:

**The destination eventually detects the source event as a clean one-cycle pulse.**

---

## Limitation of Toggle-Based CDC

A toggle synchronizer cannot safely handle arbitrarily fast events.

Suppose two pulses arrive too quickly:

```
Pulse 1 → toggle 0 → 1
Pulse 2 → toggle 1 → 0
```

before the destination has observed the first transition.

The destination might sample:

```
0 → 0
```

and completely miss the intermediate state.

Therefore, the source pulses must be sufficiently spaced apart.

The source should not generate another event until the previous toggle has had enough time to propagate through the destination synchronizer.

---

## What Happens With Back-to-Back Pulses?

If pulses arrive before the previous toggle has crossed the clock domain boundary:

```
Pulse 1 → 0 → 1
Pulse 2 → 1 → 0
```

the destination may not observe either transition correctly.

This can result in:

- Missed events
- Incorrect pulse count
- Loss of event information

Therefore, the toggle synchronizer is best suited for relatively infrequent events such as:

- Interrupts
- Status events
- Error notifications
- Control events
- Configuration updates

For high-rate event or data transfer, other CDC techniques may be more appropriate.

---

## Toggle Synchronizer vs Direct Pulse Synchronizer

**Direct 2-Flop Synchronizer**
```
pulse_in
   ↓
sync_1
   ↓
sync_2
```

Problem:
```
Short pulse
     ↓
May occur between destination clock edges
     ↓
Pulse can be missed
```

**Toggle-Based Synchronizer**
```
pulse_in
   ↓
toggle
   ↓
sync_1
   ↓
sync_2
   ↓
XOR
   ↓
pulse_out
```

Advantage:
```
Short pulse
     ↓
Persistent toggle change
     ↓
Destination can observe it later
     ↓
Clean destination pulse
```

---

## Reset Handling

The source and destination domains have independent synchronous resets.

**Source Reset**

`rst_src` resets the source toggle:

```
rst_src
   ↓
toggle = 0
```

**Destination Reset**

`rst_dst` resets the destination-domain registers:

```
rst_dst
   ↓
sync_1 = 0
sync_2 = 0
sync_d = 0
pulse_out = 0
```

The source reset is not directly used to reset destination-domain registers, and the destination reset is not directly used to reset source-domain registers.

This keeps the clock domains independent.

Independent resets during active toggle propagation must be handled carefully because a reset-induced toggle transition can potentially be interpreted as an event.

---

## Interview Concepts & Quick Revision

**Why can't a 2-flop synchronizer directly transfer a short pulse?**

A 2-flop synchronizer only samples the input on destination clock edges. If the pulse begins and ends between two destination clock edges, the destination never samples the high level and the pulse is lost.

**What problem does the toggle solve?**

The toggle converts a short transient pulse into a persistent state change.

Instead of trying to capture:
```
0 → 1 → 0
```
during a short interval, the destination detects:
```
0 → 1
```
and the state remains changed until another event occurs.

**Why do both 0→1 and 1→0 represent events?**

Because every source pulse causes the toggle to invert.

Therefore:
```
Pulse 1 → 0 → 1
Pulse 2 → 1 → 0
Pulse 3 → 0 → 1
```

Both rising and falling transitions represent valid source events.

**Why is XOR used?**

XOR detects whether the synchronized toggle changed compared with its previous value.

```
Current = Previous → XOR = 0
Current ≠ Previous → XOR = 1
```

Therefore, XOR naturally generates a pulse whenever a toggle transition is detected.

**Why is a delayed copy required?**

Without the delayed copy, the destination would only know the current state of the toggle.

By storing the previous value:
```
sync_2     = current
sync_d     = previous
```
the design can detect a transition using:
```
sync_2 ^ sync_d
```

**What determines the maximum safe pulse rate?**

The destination clock and synchronizer latency determine how quickly the destination can observe successive toggle transitions.

The source must provide enough spacing between pulses for each toggle change to propagate through the destination synchronizer.

**What happens if two pulses arrive too quickly?**

The toggle may change twice before the destination observes the first change:
```
0 → 1 → 0
```

The destination may only observe:
```
0 → 0
```

and lose the events.

Therefore, a toggle synchronizer should not be used when events can occur faster than the CDC mechanism can safely capture them.

**What if the data associated with the pulse is multi-bit?**

A toggle synchronizer transfers the event, not a multi-bit data payload.

If a pulse indicates that a multi-bit value is ready, synchronizing only the pulse does not automatically guarantee that all data bits are safely transferred.

For high-throughput or reliable multi-bit CDC, an asynchronous FIFO or an appropriate handshake-based CDC technique is generally preferred.

**Why is this a CDC problem?**

The source and destination clocks are independent:
```
clk_src ≠ clk_dst
```

Therefore, signals crossing between them can violate setup and hold requirements of destination flip-flops and potentially cause metastability.

The toggle signal is therefore synchronized before being used in the destination domain.

---

## Key Learning

- Learned why a simple 2-flop synchronizer can miss a short pulse.
- Understood the difference between level synchronization and pulse/event synchronization.
- Learned how to convert a short pulse into a persistent toggle.
- Implemented a toggle flip-flop in the source clock domain.
- Used a 2-flop synchronizer to safely transfer the toggle into the destination clock domain.
- Learned how to detect both rising and falling toggle transitions.
- Used a delayed synchronized toggle and XOR to regenerate a one-cycle destination pulse.
- Understood why `pulse_out` appears several destination-clock cycles after `pulse_in`.
- Learned that the destination does not need to directly sample the original source pulse.
- Understood the limitation on the minimum spacing between source pulses.
- Learned why toggle-based CDC is suitable for relatively infrequent events but not high-rate data transfer.
- Understood why multi-bit CDC requires additional techniques such as asynchronous FIFOs or handshaking.
- Learned how independent source and destination resets affect CDC logic.

---

## Simulation Result

The design was verified using simulation with:

```
clk_src = 100 MHz
clk_dst = 25 MHz
```

The source clock was intentionally made faster than the destination clock to demonstrate that the original short pulse can occur entirely between destination clock edges.

The waveform verified:

- ✔ `pulse_in` generated as a short source-domain pulse.
- ✔ Source toggle changes state whenever `pulse_in` is asserted.
- ✔ Original `pulse_in` does not need to be sampled directly by `clk_dst`.
- ✔ Toggle successfully propagates through the 2-flop synchronizer.
- ✔ `sync_1` and `sync_2` operate in the destination clock domain.
- ✔ XOR detects the synchronized toggle transition.
- ✔ `pulse_out` is generated in the destination clock domain.
- ✔ `pulse_out` remains high for exactly one destination-clock cycle.
- ✔ Multiple valid source events produce corresponding destination pulses when sufficiently spaced.
- ✔ Destination pulse appears after the expected synchronization latency.

---

## Conclusion

This project demonstrates a Toggle-Based Single-Pulse CDC Synchronizer for safely transferring single-cycle events between independent clock domains.

A direct pulse synchronizer can lose short pulses because the destination clock may never sample the pulse while it is high. The toggle-based approach solves this by converting each source pulse into a persistent state transition.

The toggle is then passed through a 2-flop synchronizer in the destination domain. A delayed copy of the synchronized toggle is compared using XOR to detect both rising and falling transitions and regenerate a clean one-cycle destination pulse.

The complete concept is:

```
Short Pulse
     ↓
Toggle
     ↓
2-Flop Synchronizer
     ↓
Delayed Toggle
     ↓
XOR
     ↓
Destination Pulse
```

The main limitation is that source events must be sufficiently spaced apart. If events arrive faster than the destination can observe the toggle transitions, events can be lost. For high-rate or multi-bit CDC, more advanced techniques such as handshake synchronizers or asynchronous FIFOs are required.
