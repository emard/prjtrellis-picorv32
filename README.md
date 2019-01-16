# prjtrellis-picorv32

Attempt to merry picorv32 and FPGArduino.

FPGArduino bootloader from f32c project (HEX mode-only, no binary)
is included as picorv32 firmware and compiles to less than 1024 bytes
binary.

Bootloader works at 115200 baud, responds with rv32> prompt and
accepts fpgardino's "HEX" protocol (HEX is not a real protocol
it is just upload of SREC file to the prompt and ignoring the CRCs).

picorv32 SOC will halt on any bus error, usually any f32c specific
iomem soc access will halt it. For quick fix in FPGArduino, comment
f32c specific initialization in make.cpp:

    ~/.arduino15/packages/FPGArduino/hardware/f32c/1.0.0/cores/f32c/main.cpp
    around line 46:
    // f32c_specific_initialization();

So don't use digitalWrite() for now. Do your picorv32 blinkled like this:

    #define LED (*(volatile uint32_t*)0x02000000)
    LED = 0;
    LED = 0xFF;
