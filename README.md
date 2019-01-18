# prjtrellis-picorv32

Attempt to merry picorv32 and FPGArduino.
Compiles with latest prjtrellis and fits to ECP5.
People reported that it also compiles with arachne-pnr and fits to ICE40.

# Bootloader

"firmware.c" contains ported FPGArduino bootloader from f32c project
(HEX mode-only, no binary). It compiles to less than 1024 bytes
binary using the same RISC-V gcc from FPGArduino.

Bootloader works at 115200 baud from 25 MHz clock.
Responds with "rv32>" prompt and accepts FPGArdino's
"HEX" protocol (HEX is not a real protocol it is just
upload of SREC file to the prompt and ignoring the CRCs).

Baud rate can be changed with uart clock divisor in "firmware.c"

    reg_uart_clkdiv = F_CPU/BAUD_RATE; // sets baudrate (115200 @ 25 MHz)

FPGArduino by default uploads binary staring from 1K up.
Bootloader starts from addr 0 and we try too keep it shorter than 1K.
If the bootloader is longer, FPGArduino upload address can be changed
in boards.txt.

    fpga_generic.menu.ramsize.32.compiler.ld.extra_flags=--section-start=.init=0x400

# Changing RAM size

This project by default compiles FPGA core with 32K BRAM.
If you need to change RAM size you should change something
on several places:

1. "attosoc.v": number of 8192 32-bit words = 32K RAM

    parameter integer MEM_WORDS = 8192;

2. "firmware.c": Bootloader should set stack pointer on RAM top before jumping to uploaded code:

    li s0, 0x00008000; /* 32K RAM top = stack address */

3. "sections.lds": linker should know about the RAM top

    RAM (xrw)       : ORIGIN = 0x00000000, LENGTH = 0x008000 /* 32 KB */

# FPGArduino

picorv32 SOC will halt on any bus error, usually any f32c specific
iomem SOC access will halt it. Under FPGArduino "tools" pulldown menu,
select:

    Board: Generic FPGA board
    CPU Architecture: RISC-V
    Protocol: HEX 115.2 kbit/s no verify RS232

This will pass compiler option -D__F32C__=0 to avoid
f32c_specific_initialization() in make.cpp:

    ~/.arduino15/packages/FPGArduino/hardware/f32c/1.0.0/cores/f32c/main.cpp
    around line 46:
    #if __F32C__ == 1
    f32c_specific_initialization();
    #endif

Also don't use digitalWrite() or anything similar for now.
Do your picorv32 IO directly to hardware iomem address.

LED Blinky should look like this:

    #define LED (*(volatile uint32_t*)0x02000000)
    void setup()
    {
    }
    void loop()
    {
      LED = 0;
      for(int i = 0; i < 1000000; i++)
        asm("nop");
      LED = 0xFF;
      for(int i = 0; i < 1000000; i++)
        asm("nop");
    }

