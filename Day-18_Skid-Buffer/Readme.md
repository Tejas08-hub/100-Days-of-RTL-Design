# Day 18 — Valid/Ready Skid Buffer

## Question of the Day

### Problem Statement

Design a **Valid/Ready Skid Buffer**, a fundamental flow-control structure used in streaming interfaces such as **AXI-Stream** and on-chip interconnects.

A skid buffer provides temporary storage when the downstream receiver suddenly stops accepting data. It allows the sender to continue for one additional transaction before backpressure is applied.

### Module Declaration

```verilog
module top_module #(
    parameter WIDTH = 8
)(
    input                   clk,
    input                   reset,

    input  [WIDTH-1:0]      in_data,
    input                   in_valid,
    output                  in_ready,

    output [WIDTH-1:0]      out_data,
    output                  out_valid,
    input                   out_ready
);
```

### Requirements

- Implement a Valid/Ready Skid Buffer.
- Use a synchronous active-high reset.
- Support a parameterized data width.
- Follow the standard Valid/Ready handshake protocol.
- A transfer occurs only when both valid and ready are high in the same cycle.
- Provide a main storage location for the current output transaction.
- Provide one additional skid buffer entry for absorbing an extra transaction.
- `in_ready` must correctly indicate whether the buffer can accept another transaction.
- When the buffer is empty and the receiver is ready, allow data to pass through without unnecessary latency.
- When the receiver stalls, preserve the current output data.
- Store one additional incoming transaction in the skid buffer during a stall.
- Once both storage locations are occupied, `in_ready` must go low.
- When the receiver becomes ready again, drain transactions in the correct order.
- Correctly handle simultaneous output transfer and new input acceptance.

### Understanding the Valid/Ready Protocol

The Valid/Ready interface consists of four important signals:

| Signal | Controlled By | Meaning |
|---|---|---|
| `in_valid` | Sender | Input data is valid |
| `in_ready` | Skid Buffer | Buffer can accept input data |
| `out_valid` | Skid Buffer | Output data is valid |
| `out_ready` | Receiver | Receiver can accept output data |

**Input Transfer**

A transaction enters the buffer when:

```
in_valid && in_ready
```

Both signals must be high during the same cycle.

**Output Transfer**

A transaction leaves the buffer when:

```
out_valid && out_ready
```

Both signals must be high during the same cycle.

### My Approach

Designed the skid buffer using two storage locations:

- **Main Buffer** — stores the transaction currently presented to the receiver.
- **Skid Buffer** — stores one additional transaction when the receiver becomes unavailable.

The basic structure is:

```
                 MAIN BUFFER
              +-------------+
in_data ----->|             |-----> out_data
              | Main Storage|
              +------+------+
                     |
                     v
                  Receiver

                 SKID BUFFER
              +-------------+
              |             |
              |Extra Storage|
              +-------------+
```

The main buffer uses:

```
main_data
main_valid
```

The skid buffer uses:

```
skid_buff
skid_buff_valid
```

The valid signals indicate whether the corresponding storage location currently contains a valid transaction.

### Working Principle

**Case 1 — Normal Pass-Through**

When the receiver is ready and the buffer has available space:

```
in_valid  = 1
out_ready = 1
```

The input transaction can move toward the output without unnecessary buffering.

Example:

```
10 → 20 → 30
```

The receiver accepts each transaction normally.

**Case 2 — Receiver Stalls**

Suppose the receiver suddenly deasserts:

```
out_ready = 0
```

while valid output data is already present.

The current output transaction must remain unchanged.

For example:

```
Main = 40
Receiver = Not Ready
```

Therefore:

```
out_valid = 1
out_data  = 40
out_ready = 0
```

The value 40 must remain available until the receiver accepts it.

If another valid transaction arrives:

```
in_data = 50
```

it can be stored in the skid buffer:

```
Main = 40
Skid = 50
```

**Case 3 — Both Storage Locations Become Full**

If another transaction arrives while:

```
Main = 40
Skid = 50
```

the buffer has no additional storage.

Therefore:

```
in_ready = 0
```

This provides backpressure to the sender.

The sender must keep its valid transaction available until the buffer can accept it.

**Case 4 — Receiver Becomes Ready Again**

When:

```
out_ready = 1
```

the main transaction can leave.

For example:

```
Main = 40
Skid = 50
```

After 40 is consumed:

```
40 → Receiver
50 → Main
```

The skid buffer becomes empty.

The next output transaction is therefore:

```
50
```

The ordering is preserved:

```
40 → 50
```

**Case 5 — Simultaneous Drain and New Input**

This is one of the most important corner cases.

Suppose:

```
Main = 10
Skid = 20
Input = 99

out_ready = 1
in_valid  = 1
```

During the same clock cycle:

```
10 → Receiver
20 → Main
99 → Skid
```

After the clock:

```
Main = 20
Skid = 99
```

Therefore the receiver eventually observes:

```
10 → 20 → 99
```

This condition is important because the buffer is draining and receiving a new transaction during the same clock cycle.

### Why is it Called a Skid Buffer?

The name comes from the idea of something that cannot stop immediately.

Imagine a moving object traveling forward. If it suddenly needs to stop, its momentum causes it to continue moving slightly before coming to rest.

Similarly, in a streaming data path, the sender may already have another valid transaction available when the receiver suddenly deasserts ready.

The skid buffer provides temporary storage for that extra transaction.

Normal:

```
Sender -----------------> Receiver
```

Receiver stalls:

```
Sender ---------> Main ----X----> Receiver
                    |
                    v
               Skid Buffer
```

The skid buffer absorbs the extra transaction instead of losing it.

### Why Do We Need valid Separately from Data?

The data value itself cannot determine whether a storage location contains a valid transaction.

For example:

```
skid_buff = 0
```

does not necessarily mean the buffer is empty.

Zero can be a perfectly valid data value.

Therefore:

```
skid_buff
```

stores the actual data, while:

```
skid_buff_valid
```

indicates whether that data is valid.

For example:

```
skid_buff       = 0
skid_buff_valid = 1
```

means:

```
A valid transaction containing zero is stored.
```

Whereas:

```
skid_buff_valid = 0
```

means:

```
The skid storage location is empty.
```

### Backpressure

Backpressure occurs when the receiver cannot accept more data.

For example:

```
out_ready = 0
```

If both storage locations are occupied:

```
main_valid = 1
skid_buff_valid = 1
```

then:

```
in_ready = 0
```

This tells the sender that the buffer cannot accept another transaction.

The sender can keep:

```
in_valid = 1
```

and must keep its current data stable until:

```
in_valid && in_ready
```

becomes true.

### Skid Buffer vs FIFO

A skid buffer and FIFO both provide temporary storage, but they serve different purposes.

**FIFO**

A FIFO is designed to store multiple transactions.

```
Input → [1] [2] [3] [4] [5] → Output
```

It is useful when the producer and consumer operate at different rates for an extended period.

**Skid Buffer**

A skid buffer normally provides only a small amount of additional storage.

```
Main → Skid
```

Its primary purpose is to handle short-term stalls while maintaining high throughput and helping break long handshake paths.

### Why is ready Often a Timing Problem?

In a Valid/Ready interface, ready is generated by the receiving side.

It can propagate backward through multiple modules:

```
Module A → Module B → Module C → Module D
   ↑          ↑          ↑          ↑
 ready ←──── ready ←──── ready ←──── ready
```

This can create a long combinational path.

A long ready path can increase propagation delay and make it difficult to meet timing constraints.

A skid buffer can help break this path by providing registered storage and allowing temporary buffering.

### Why Must the Sender Hold valid?

Once the sender asserts:

```
in_valid = 1
```

it must keep the transaction valid until:

```
in_valid && in_ready
```

occurs.

For example:

```
in_valid = 1
in_ready = 0
```

means the transaction has not transferred yet.

The sender must keep the same data available.

If the sender were allowed to withdraw or change the transaction before the transfer, the receiver could miss data and the skid buffer could capture inconsistent information.

### Important Corner Case

One of the most important cases in the design is:

```
Main = A
Skid = B
New input = C

out_ready = 1
in_valid  = 1
```

The correct behavior is:

```
A → Receiver
B → Main
C → Skid
```

The sequence must remain:

```
A → B → C
```

No transaction may be lost.

This simultaneous drain + refill condition is an important verification point for a skid buffer.

### Testbench Scenarios

The testbench verifies three major scenarios.

**Scenario 1 — Pass-Through**

The receiver keeps:

```
out_ready = 1
```

Input data is sent as:

```
10 → 20 → 30
```

Expected behavior:

```
10 → 20 → 30
```

should reach the output correctly.

**Scenario 2 — Receiver Stall**

The receiver deasserts:

```
out_ready = 0
```

while the sender continues presenting valid data.

Example:

```
40 → 50 → 60
```

Expected behavior:

```
40
```

remains at the output.

The next transaction:

```
50
```

is stored in the skid buffer.

Once both storage locations are occupied:

```
in_ready = 0
```

and the next transaction must not be accepted until space becomes available.

**Scenario 3 — Receiver Unstalls**

The receiver becomes ready again:

```
out_ready = 1
```

The stored transactions must drain in order.

For example:

```
40 → 50
```

must be observed at the receiver in exactly that order.

The design must not lose, duplicate, or reorder transactions.

**Scenario 4 — Simultaneous Drain and Refill**

The testbench also verifies the difficult corner case:

```
Main = 10
Skid = 20
New input = 99
out_ready = 1
in_valid = 1
```

Expected sequence:

```
10 → 20 → 99
```

This verifies that a new transaction is not lost when the buffer is simultaneously draining and accepting new data.

### Key Learning

- Learned the Valid/Ready handshake protocol.
- Understood that a transfer occurs only when valid && ready are both high.
- Learned the difference between valid and ready.
- Understood how backpressure propagates from receiver to sender.
- Designed a two-entry skid buffering structure.
- Learned why data and its valid status must be stored separately.
- Understood how a skid buffer handles temporary receiver stalls.
- Learned how in_ready prevents buffer overflow.
- Understood the difference between a skid buffer and a FIFO.
- Learned why long combinational ready paths can create timing problems.
- Understood why the sender must hold valid and data until a transfer occurs.
- Verified the difficult simultaneous drain-and-refill condition.
- Learned how skid buffers help maintain throughput while handling short stalls.

### Simulation Result

- ✔ Valid/Ready handshake behavior verified.
- ✔ Normal pass-through operation verified.
- ✔ Input data transfers when in_valid && in_ready are high.
- ✔ Output data transfers when out_valid && out_ready are high.
- ✔ Receiver stall condition successfully tested.
- ✔ Current output data remains stable while out_ready = 0.
- ✔ Additional transaction successfully stored in the skid buffer.
- ✔ in_ready goes low when the available storage is full.
- ✔ Stored transactions drain correctly when the receiver becomes ready.
- ✔ Data ordering is preserved during buffering and recovery.
- ✔ Simultaneous output drain and new input acceptance verified.
- ✔ No transaction loss observed during the tested corner cases.
- ✔ Simulation waveform verified the Main Buffer and Skid Buffer behavior.
