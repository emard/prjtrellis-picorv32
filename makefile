# ******* project, board and chip name *******
PROJECT = picorv32
BOARD = ulx3s
# 12 25 45 85 (but this project routes only on 45 and 85)
FPGA_SIZE = 12

# ******* design files *******
CONSTRAINTS = ulx3s_v20_segpdi.lpf
TOP_MODULE = top
TOP_MODULE_FILE = $(TOP_MODULE).v
VERILOG_FILES = $(TOP_MODULE_FILE) attosoc.v picorv32.v simpleuart.v
VHDL_TO_VERILOG_FILES =

# synthesis options
# YOSYS_OPTIONS = -noccu2

F32C-COMPILER-PATH=~davor/.arduino15/packages/FPGArduino/tools/f32c-compiler/1.0.0/bin
RISCV32-GCC=$(F32C-COMPILER-PATH)/riscv32-elf-gcc
RISCV32-OBJCOPY=$(F32C-COMPILER-PATH)/riscv32-elf-objcopy

firmware.hex:

firmware.elf: sections.lds start.s firmware.c
	$(RISCV32-GCC) -march=rv32i -mabi=ilp32 -Wl,-Bstatic,-T,sections.lds,--strip-debug -ffreestanding -nostdlib -o firmware.elf start.s firmware.c

firmware.bin: firmware.elf
	$(RISCV32-OBJCOPY) -O binary firmware.elf /dev/stdout > firmware.bin

firmware.hex: firmware.bin
	python3 makehex.py $^ 4096 > $@

include scripts/ulx3s_trellis.mk
