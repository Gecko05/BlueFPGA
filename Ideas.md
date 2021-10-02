# Emulator

A software emulator would be handy.

# Interfaces

## Loading new values into the RAM from PC

* Need to use the serial port to write into the RAM from the PC
* Each RAM address consists of 2 bytes

### First version

Blu needs to be in HALT state before writing into the RAM to avoid complications.
A button will be used to put Blu into HALT RAM read mode, then the PC will be able to start pumping data.
Data will be overwritten starting from address #0 and increasing byte by byte.

## Debugging

Blu needs a debugging interface.

### First version

Blue have a switch that will put it into debug mode.
In debug mode, breakpoints will be able to be set, Blue will pump data through the serial port.