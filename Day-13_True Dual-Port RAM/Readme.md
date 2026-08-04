# Day 13 — True Dual-Port RAM

## Question of the Day

### Problem Statement

Design a Verilog module that implements a **True Dual-Port RAM**, where **both ports can independently read from or write to memory** using the same clock.

### Module Declaration

```verilog
module top_module #(
    parameter ADDR_WIDTH = 6,
    parameter DATA_WIDTH = 8
)(
    input clk,

    input                    wr_en_a,
    input  [ADDR_WIDTH-1:0]  addr_a,
    input  [DATA_WIDTH-1:0]  data_in_a,
    output reg [DATA_WIDTH-1:0] data_out_a,

    input                    wr_en_b,
    input  [ADDR_WIDTH-1:0]  addr_b,
    input  [DATA_WIDTH-1:0]  data_in_b,
    output reg [DATA_WIDTH-1:0] data_out_b
);
```

### Requirements

- Implement a **True Dual-Port RAM** with two fully independent ports.
- Both ports operate using the **same clock**.
- Each port can independently perform **read** or **write** operations.
- Support **simultaneous reads**, **simultaneous writes to different addresses**, and **independent read/write operations**.
- Implement **write-first behavior** on the same port, meaning a port immediately sees its own newly written data.
- During a **cross-port read-during-write**, the reading port must observe the **old memory value** while the writing port updates memory.
- Handle simultaneous writes to the same address by defining a conflict policy. In this implementation, **Port B is given priority**.
- Model the memory using:

```verilog
reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
```

- Use **non-blocking assignments (`<=`)**.
- Implement the design using **clocked `always @(posedge clk)` blocks.

---

## My Approach

Designed the memory using a **True Dual-Port RAM architecture**, where both ports share the same memory array while operating independently.

The implementation consists of:

- **Shared Memory Array** – Stores all memory locations and is accessible by both ports.
- **Port A** – Independently performs read and write operations using its own address, write enable, and data signals.
- **Port B** – Independently performs read and write operations using a separate interface while accessing the same memory.
- **Write-First Behavior** – When a port writes to its own address, the corresponding output immediately reflects the newly written data.
- **Cross-Port Read Handling** – If one port writes while the other reads the same address during the same clock cycle, the reading port observes the previous memory value because memory updates occur after the clock edge.
- **Write Conflict Handling** – If both ports attempt to write to the same memory location simultaneously, **Port B is given priority**, ensuring deterministic behavior.

---

## Key Learning

- Understood the architecture and operation of a **True Dual-Port RAM**.
- Learned the difference between **single-port** and **dual-port** memories.
- Understood how two independent ports can simultaneously access the same memory.
- Learned the concept of **write-first** memory behavior.
- Understood **cross-port read-during-write**, where the reading port observes the old memory value while another port performs a write.
- Learned why simultaneous writes to the same address require a clearly defined conflict resolution policy.
- Understood how **non-blocking assignments** determine memory update timing in sequential logic.
- Learned how memory depth is determined using the address width (`2^ADDR_WIDTH`) while each location stores `DATA_WIDTH` bits.
- Understood the importance of using coding styles that allow synthesis tools to infer block RAM correctly.

---

## Simulation Result

✔ Successfully verified independent read and write operations on both ports.

✔ Verified **same-port write-first** behavior.

✔ Verified **cross-port read-during-write**, where the reading port observes the previous memory value.

✔ Successfully performed simultaneous writes to different memory addresses.

✔ Verified simultaneous writes to the same address using the defined **Port B wins** conflict policy.

✔ Verified correct memory operation using simulation waveforms.

---

# Part B — Conceptual Understanding

## Why does a Dual-Port RAM have read-during-write ambiguity while a Single-Port RAM does not?

A **Single-Port RAM** has only one interface, so only one operation (read or write) is performed through that port at a time. This eliminates ambiguity during memory access.

A **Dual-Port RAM** allows two independent ports to access the same memory simultaneously. When one port writes to an address while the other reads the same address during the same clock cycle, the designer must define what the reading port should observe. This creates the read-during-write behavior that must be handled carefully.

---

## Read-First vs Write-First vs No-Change

### Write-First

The writing port immediately observes the newly written data after the write operation.

### Read-First

The port first reads the old memory value before the write updates the memory.

### No-Change

The output retains its previous value during a write operation instead of showing either the old or new memory data.

This implementation uses **Write-First** behavior for the writing port.

---

## Why do FPGA vendors provide configurable read-during-write modes?

Different applications require different memory behavior. Some applications need immediate access to newly written data, while others require the previous memory value or a stable output during writes.

Providing configurable modes allows designers to select the behavior that best matches their application while efficiently utilizing FPGA Block RAM resources.

---

## Additional Interview Concepts

### Why is a conflict policy required for simultaneous writes?

If both ports write different data to the same address during the same clock cycle, the final memory content becomes ambiguous unless a priority is defined.

To ensure deterministic behavior, this implementation defines **Port B** as the winner during simultaneous write conflicts.

---

### Why are Non-Blocking Assignments important?

Non-blocking assignments update all registers simultaneously at the end of the clock edge.

This accurately models hardware behavior and ensures correct implementation of read-during-write timing.

---

### Why is the memory declared as `reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1]`?

`DATA_WIDTH` defines the number of bits stored at each memory location, while `ADDR_WIDTH` determines the total number of memory locations.

For example:

- `ADDR_WIDTH = 6` creates **64 memory locations**
- `DATA_WIDTH = 8` stores **8 bits per location**

---

## Conclusion

This project demonstrates the implementation of a **True Dual-Port RAM**, one of the most widely used memory architectures in FPGA and ASIC designs. The design supports independent dual-port memory access, write-first behavior, cross-port read-during-write handling, and simultaneous memory operations. Along with the RTL implementation, this exercise highlights important memory concepts such as dual-port access, memory conflict resolution, read-during-write behavior, and deterministic write arbitration. The design was verified through simulation using multiple read and write scenarios, providing a solid understanding of practical dual-port memory implementation.
