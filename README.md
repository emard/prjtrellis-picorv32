# prjtrellis-picorv32

Attempt to merry picorv32 and FPGArduino.

FPGArduino bootloader from f32c project (HEX mode-only, no binary)
is included as picorv32 firmware and compiles to less than 1024 bytes
binary.

Bootloader works at 115200 baud, responds with rv32> prompt and
accepts fpgardino's "HEX" protocol (HEX is not a real protocol
it is just upload of SREC file to the prompt and ignoring the CRCs).

Bootloader correctly fills memory with received data and I think
more or less correctly executes a jumps to the new code, I tried
to upload different binaries and they behave different.

But compiled code from FPGArduino doesn't work properly
(doesn't blink, doesn't print etc).

Maybe it's some minor issue like initial settings of stack
pointers and other registers in FPGArduino's start.s,
wrong compiler options in FPGArduino's "boards.txt" or 
"platform.txt" or some similar issue.

Maybe you can help?

