# Day 09 — UART Transmitter (8-N-1)

## Question of the Day

### Problem Statement

Write a Verilog module that implements a **UART Transmitter** using the standard **8-N-1** frame format. The transmitter serializes an 8-bit parallel input and transmits it one bit at a time using a **Finite State Machine (FSM)**, **Baud Rate Generator**, and **Shift Register**.

### Module Declaration

```verilog
module top_module #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input        clk,
    input        reset,
    input        tx_start,
    input  [7:0] tx_data,
    output reg   tx,
    output       tx_busy
);
```

### Requirements

- Implement a **Baud Rate Generator** to generate one baud tick per bit period.
- Keep the UART line **HIGH** during the idle state.
- On receiving `tx_start`, latch `tx_data` into an internal shift register.
- Transmit the UART frame in the following order:
  - **1 Start Bit (0)**
  - **8 Data Bits (LSB First)**
  - **No Parity**
  - **1 Stop Bit (1)**
- Hold each transmitted bit for exactly one baud period.
- Keep `tx_busy` asserted throughout the transmission.
- Return to the idle state after transmitting the stop bit.
- Use synchronous active-high reset.
- Use **non-blocking assignments (`<=`)**.
- Implement the design using a **clocked FSM**, **Baud Rate Generator**, and **Shift Register**.

---

## My Approach

Designed the UART transmitter by dividing the design into three functional blocks:

- **Baud Rate Generator** – Generates a `baud_tick` by dividing the system clock according to the selected baud rate.
- **UART Transmitter FSM** – Controls the transmission using four states:
  - **IDLE** – UART line remains HIGH while waiting for a transmission request.
  - **START** – Sends the start bit (`0`) for one baud period.
  - **DATA** – Transmits the 8 data bits serially, beginning with the Least Significant Bit (LSB).
  - **STOP** – Sends the stop bit (`1`) before returning to the idle state.
- **Shift Register** – Stores the input byte and shifts one bit every baud tick until all eight bits are transmitted.

The baud generator provides the timing reference, the FSM controls the transmission sequence, and the shift register converts the parallel input into serial data, ensuring that every UART bit is transmitted for exactly one baud period.

---

## Key Learning

- Understood the working principle of **UART asynchronous serial communication**.
- Learned why the UART line remains **HIGH** during the idle state and why the **start bit is always LOW**.
- Implemented a **Baud Rate Generator** to derive the required baud timing from the system clock.
- Designed a **Finite State Machine (FSM)** to control the UART transmission process.
- Used a **Shift Register** to serialize an 8-bit parallel input into serial output.
- Learned that UART transmits data **LSB first**.
- Implemented the `tx_busy` signal to prevent new transmission requests during an active transmission.
- Understood how the baud generator, FSM, and shift register work together to generate a complete UART frame.
- Learned to reduce simulation time by using scaled parameters (`CLK_FREQ = 1000`, `BAUD_RATE = 100`) while preserving the transmitter logic.

---

## Simulation Result

✔ UART line remains **HIGH** during the idle state.

✔ Start bit (`0`) is transmitted correctly.

✔ All **8 data bits** are transmitted in **LSB-first** order.

✔ Stop bit (`1`) is transmitted correctly.

✔ `tx_busy` remains HIGH throughout the complete transmission.

✔ Baud generator produces one `baud_tick` for every bit period.

✔ UART frame timing and state transitions verified using simulation waveforms.

✔ Simulation performed using reduced clock and baud-rate parameters for faster verification without changing the UART functionality.
