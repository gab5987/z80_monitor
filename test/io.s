
#define IO_START_ADDR 0b0010100000000000
#define IO_ADDR_SETUP 0b0010100000000011

#define IO_DATA_ALL_OUT 0b10000000

.org 0x00
_start:
    ld hl, 0b0010100000000011 # loads ALL_OUT to HL
    ld (hl), 0b10000000
    ld hl, 0b0010100000000000
    ld d, 0x00
_loop:
    ld (hl), d
    inc d
_await:
    ld b, 0x00
_loop_cond:
    ld a, 50
    cp b
    jp z, _loop_exit
.org 0x0750
    inc b 
    jp _loop_cond
_loop_exit:
    jp _loop

    halt

.org 0x0800
