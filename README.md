# prjtrellis-picorv32

Attempt to merry picorv32 and FPGArduino.

FPGArduino bootloader from f32c project (HEX mode-only, no binary)
is included as picorv32 firmware and compiles to less than 1024 bytes
binary.

Bootloader works at 115200 baud from 25 MHz clock.
Responds with rv32> prompt and accepts fpgardino's
"HEX" protocol (HEX is not a real protocol it is just
upload of SREC file to the prompt and ignoring the CRCs).

Baud rate can be changed with uart clock divisor in "firmware.c"

    reg_uart_clkdiv = 416/2; // sets baudrate 115200 @ 25 MHz

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
Blinky should look this:

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

