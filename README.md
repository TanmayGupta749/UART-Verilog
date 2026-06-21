# UART Transmitter and Receiver in Verilog HDL

## Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) in Verilog HDL. The design includes a UART Transmitter, UART Receiver, Parameterized Baud Rate Generator, Parity Generation/Checking, and Error Detection mechanisms. The design was simulated and verified using Xilinx Vivado.

---

## Features

- Parameterized Baud Rate Generator
- UART Transmitter (TX)
- UART Receiver (RX)
- FSM-Based Design
- Start Bit Detection
- Stop Bit Detection
- Even Parity Generation
- Parity Error Detection
- Framing Error Detection
- TX Busy Flag
- TX Done Flag
- RX Done Flag
- Verilog Testbench Verification

---

## Project Structure

```
UART-Verilog
│
├── RTL
│   ├── Baudgenerator.v
│   ├── UART_TX.v
│   ├── UART_RX.v
│   └── UART_connection.v
│
├── Testbench
│   └── UART_tb.v
│
├── Images
│   ├── rtl_block_diagram.png
│   ├── synthesized_schematic.png
│   └── uart_waveform.png
│
├── Docs
│   └── UART_Project_Report.pdf   (optional)
│
└── README.md
```

---

## UART Frame Format

| Start Bit | Data Bits | Parity Bit | Stop Bit |
|------------|------------|------------|-----------|
| 1 bit | 8 bits | 1 bit | 1 bit |

---

## Design Modules

### Baud Generator
Generates baud tick pulses based on clock frequency and baud rate parameters.

### UART Transmitter
- Serializes 8-bit parallel data
- Generates parity bit
- Controls transmission using FSM
- Provides TX Busy and TX Done flags

### UART Receiver
- Receives serial data
- Reconstructs 8-bit parallel data
- Checks parity correctness
- Detects framing errors
- Provides RX Done flag

---

## Error Detection

### Parity Error Detection
Compares:
- Received parity bit
- Calculated parity from received data

Sets `parity_error = 1` when mismatch occurs.

### Framing Error Detection
Checks stop bit value.

Sets `frame_error = 1` if stop bit is not logic high.

---

## Simulation Results

Verified using Vivado Simulator with multiple test vectors:

| Input Data | Output Data | Result |
|------------|-------------|---------|
| 8'h8F | 8'h8F | Pass |
| 8'h9C | 8'h9C | Pass |

- Parity Error = 0
- Framing Error = 0
- TX Done and RX Done flags verified

---

## Tools Used

- Verilog HDL
- Xilinx Vivado
- FSM-Based RTL Design

---
