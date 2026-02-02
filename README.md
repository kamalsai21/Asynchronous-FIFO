# Asynchronous-FIFO
A synthesizable dual-clock Asynchronous FIFO in Verilog with independent read/write clocks. It uses Gray-coded pointers, two-flop synchronizers for safe clock-domain crossing, and a wrap-bit technique for reliable full/empty detection. The design is modular and verified with a self-checking testbench (40 MHz write, 50 MHz read).
