# Day 03 — Synchronous FIFO (Full/Empty Flags)

## Question of the Day

### Problem Statement

Write a Verilog module that implements a **Synchronous FIFO (First-In First-Out)** with configurable depth and width using a **single clock** for both read and write operations.

### Module Declaration

```verilog
module fifo #(
    parameter width = 8,
    parameter depth = 8
)(
    input clk,
    input reset,
    input wr_en,
    input [width-1:0] d_in,
    input rd_en,
    output reg [width-1:0] d_out,
    output full,
    output empty
);
```

### Requirements

- Design a **Synchronous FIFO** using a single clock for both read and write operations.
- Implement the FIFO using a **register array** for internal storage.
- Support configurable **data width** and **FIFO depth** using parameters.
- Use read and write pointers that are **$clog2(DEPTH)+1** bits wide to correctly detect **Full** and **Empty** conditions.
- Assert **full** when the FIFO cannot accept additional data.
- Assert **empty** when there is no valid data available for reading.
- Ignore write requests while the FIFO is full to prevent overflow.
- Ignore read requests while the FIFO is empty to prevent underflow.
- Support simultaneous read and write operations during normal FIFO operation.
- Use a synchronous active-high reset.
- Update all sequential logic on the **rising edge** of `clk`.
- Use **non-blocking assignments (`<=`)**.

---

## My Approach

Designed the FIFO using a **memory-based architecture** with separate **write** and **read pointers** to control data storage and retrieval.

The implementation consists of:

- **Memory Array** – Stores the FIFO data.
- **Write Pointer** – Tracks the next location where incoming data will be written.
- **Read Pointer** – Tracks the next location from which data will be read.
- **Full Flag Logic** – Detects when the FIFO has reached its maximum capacity by comparing the write and read pointers using an additional wrap-around bit.
- **Empty Flag Logic** – Detects when all stored data has been read by comparing both pointers.

The read and write pointers are implemented with an **extra Most Significant Bit (MSB)** beyond the memory address width. This additional bit distinguishes the **Full** condition from the **Empty** condition when both pointers reference the same memory location after wrap-around.

The design also supports simultaneous read and write operations while preventing overflow and underflow through proper control logic.

---

## Key Learning

- Understood the working principle of a **First-In First-Out (FIFO)** memory.
- Learned the difference between **Synchronous FIFO** and **Asynchronous FIFO**.
- Understood why FIFO pointers require an **extra wrap-around bit** for reliable Full and Empty detection.
- Learned that the memory address uses only the lower pointer bits, while the MSB is used for wrap detection.
- Implemented **Full** and **Empty** flag generation using pointer comparison.
- Understood how overflow and underflow are prevented using enable conditions.
- Learned how simultaneous read and write operations affect FIFO behavior.
- Verified FIFO functionality through simulation using write, read, Full, and Empty conditions.

---

## Simulation Result

✔ Successfully writes data into the FIFO.

✔ Successfully reads data in the same order it was written (FIFO behavior).

✔ Correctly asserts the **Full** flag when the FIFO reaches maximum capacity.

✔ Correctly asserts the **Empty** flag after all stored data has been read.

✔ Successfully prevents overflow and underflow conditions.

✔ Verified pointer operation, Full/Empty flag generation, and FIFO functionality using simulation waveforms.
