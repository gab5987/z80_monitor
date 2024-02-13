
# RAM = 0b0011000000000000 

.org 0x00
_start:
    ld hl, 0b0010100000000011 
    ld (hl), 0b10000000
    ld hl, 0b0011000000000000 | 0x20
    ld (hl), 0x55
    ld a, (hl)
    cp 0x55
    ld hl, 0b0010100000000000
    jp z, _no_error
    ld (hl), 0xff
    jp _exit   
_no_error:
    ld (hl), 0x55
_exit:    
    halt
.org 0x0800
