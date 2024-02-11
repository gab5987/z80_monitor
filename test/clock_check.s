
.org 0x00
_start:
    ld b, 0
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
