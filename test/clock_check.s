.org 0x00
_start:
    jp _main
.org 0x05
variable:
    .byte 0x00
.org 0x0a
_main:
    ld hl, variable
    ld b, (hl)
_loop_cond:  
    ld a, 255
    cp b
    jp z, _loop_exit
_loop_body:
    nop
    nop
.org 0x07f0
    inc b
    jp _loop_cond

_loop_exit:
    halt

.org 0x0800
