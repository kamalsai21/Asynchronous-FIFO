# Asynchronous FIFO (Dual-Clock FIFO) – Verilog Implementation

This repository contains a synthesizable Asynchronous FIFO implemented in Verilog. The FIFO supports independent read and write clock domains and uses standard clock-domain crossing techniques.

Features:

* Dual-clock FIFO with separate write and read clocks
* Gray-coded read and write pointers
* Two-flop synchronizers for safe clock-domain crossing
* Wrap-bit technique for reliable full and empty detection
* Modular structure with separate pointer and memory blocks
* Self-checking testbench

Files in the repository:

* FIFO.v        : Top-level FIFO module
* FIFO_wptr.v   : Write pointer logic
* FIFO_rptr.v   : Read pointer logic
* FIFO_mem.v    : Dual-port memory block
* synchronizer.v: Two-stage synchronizer for CDC
* tb_FIFO.v     : Self-checking testbench

Design overview:
The FIFO maintains binary pointers internally for memory addressing and converts them to Gray code before transferring across clock domains. An additional wrap bit is used to distinguish between full and empty conditions when pointer addresses match.

Full condition:
The FIFO is full when the lower address bits of the write and read pointers match and their wrap bits differ.

Empty condition:
The FIFO is empty when the binary-converted write pointer equals the read pointer.

Testbench:
The provided testbench validates correct FIFO behavior using:

* 40 MHz write clock
* 50 MHz read clock
  It checks data ordering, full and empty flags, and accounts for one-cycle read latency.

How to run:
Simulate all Verilog files together with tb_FIFO.v as the top module using your preferred simulator (Vivado, ModelSim, or iverilog).
