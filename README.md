UART Transmitter with Fractional Baud Rate Generator
---------------------------------------------------
A high-precision, synthesizable UART (Universal Asynchronous Receiver-Transmitter) Transmitter implemented in Verilog. 
This design features a 24-bit Phase Accumulator-driven Fractional Baud Rate Generator to eliminate standard integer-division timing errors, 
achieving an effective 0% average baud rate percentage error.The design has been fully simulated and verified using AMD Xilinx Vivado Design Suite.

System Architecture
------------------
The project utilizes a modular, hierarchical hardware structure consisting of three primary modules:

1.baud_generator: Uses a 24-bit accumulator to dynamically divide a high-frequency system clock 100MHz 
down to a highly precise serial communication heartbeat 9600baud.
2.uart_tx: A Finite State Machine (FSM) that captures 8-bit parallel data and serializes it 
out onto a single wire (tx) matching the standard asynchronous framing rules.
3.uart_top: The top-level structural wrapper interconnecting the timing metronome wire straight into the transmitter engine.

How the Fractional Divider Works
-------------------------------

Standard integer clock dividers drop fractional remainders when the system clock frequency doesn't split perfectly into the target baud rate, producing timing drift.
This design avoids drift by implementing a Phase Accumulator Method. 
On every rising edge of the system clock, a precise decimal tracking factor (INCREMENT) is piled into an internal 24-bit register:

<img width="577" height="96" alt="image" src="https://github.com/user-attachments/assets/8f0f74b9-51ad-4030-b15d-2db3c38833d9" />

For a standard 100MHz clock and 9600Baud:

<img width="753" height="87" alt="image" src="https://github.com/user-attachments/assets/583a2166-fa6a-4a78-b33a-a67151fb412e" />

Finite State Machine (FSM) Specification
---------------------------------------
The serialization sequence operates through a 4-State Machine framework within the uart_tx core:
<img width="1392" height="162" alt="image" src="https://github.com/user-attachments/assets/f0a212fb-d6ed-4b8c-81f2-123025871968" />

Simulation and Verification
--------------------------
The system testbench validates the hardware layout by streaming an alternating bit data frame 
(8'h55 -> 01010101 in binary) over a 100MHz simulated clock plane.
Waveform Analysis Metrics:
  Start Bit: Clear, clean high-to-low transition starting right after the initial setup delays.
  Uniform Bit Distribution: Every data bit index slot occupies an identical, balanced horizontal timeline column width across the grid.
  True Bit-7 Hold: The internal FSM protects the final Data State lane assignment, maintaining state stability for the complete duration of index 7 without early termination clipping.

Running the Project in Vivado
----------------------------
1.Clone this repository to your local environment.
2.Launch Vivado Design Suite and establish a new project environment targeting your preferred FPGA board (e.g., Digilent Basys 3).
3.Import the source assets located inside the folder "design_source" as design files and the content within "simulation_source"as simulation assets.
4.Set uart_tx_tb as the top simulation module.
5.Click Run Simulation Run Behavioral Simulation.
6.Set the run duration length field located within the top settings layout banner to 1500 us (or higher) to capture the complete serial packet streaming sequence.

<img width="1570" height="810" alt="Screenshot 2026-07-05 220348" src="https://github.com/user-attachments/assets/69404acc-89ce-4434-933c-ab512d03191b" />
