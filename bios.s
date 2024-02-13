.equ RAM_ADDR, 0b0011000000000000
.equ RAM_END, RAM_ADDR | 0x7ff

.equ IO_ADDR, 0b0010100000000000
.equ IO_ADDR_PA, IO_ADDR | 0b0000
.equ IO_ADDR_PB, IO_ADDR | 0b0001
.equ IO_ADDR_PC, IO_ADDR | 0b0010
.equ IO_ADDR_SP, IO_ADDR | 0b0011

.equ IO_DATA_ALL_OUT, 0b10000000

.org 0x0000
_rst_vec:
    # Sets up the RAM stack pointer
    ld sp, RAM_END

    # Sets up the IO expansor
    ld hl, IO_ADDR_SP
    ld (hl), IO_DATA_ALL_OUT

    call _main
    halt

_main:
    ret

.org 0x0800
