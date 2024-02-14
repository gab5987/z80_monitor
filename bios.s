.include "layout.s"

.org 0x0000
_rst_vec:
    ; Sets up the RAM stack pointer
    ld sp, RAM_END

    ; Sets up the IO expansor
    ld hl, IO_ADDR_SP
    ld (hl), IO_CONTROL_WORD_0

    jp main

.org INT_ADDR
_int_response:
    di
    ei
    ret

.org NMI_ADDR
_nmi_response:
    ret

; Awaits for the LCD to finish its instruction cycle
lcd_wait:
    push af
    ld hl, IO_ADDR_SP
    ld (hl), IO_CONTROL_WORD_8

lcd_busy:
    ld hl, LCD_CFG_ADDR
    ld (hl), LCD_RW
    ld (hl), 0b01100000 ; LCD_RW | LCD_E
    ld hl, LCD_DATA_ADDR
    ld a, (hl)
    and LCD_BUSY_FLAG
    jp nz, lcd_busy
    
    ld hl, LCD_CFG_ADDR
    ld (hl), LCD_RW

    ld (hl), IO_CONTROL_WORD_0
    pop af
    ret

; Expects instruction stored in the A register.
lcd_instruction:
    ; call lcd_wait

    ld hl, LCD_DATA_ADDR
    ld (hl), a 

    ld hl, LCD_CFG_ADDR
    ld a, 0x00 ; Clear RS/RW/E bits
    ld (hl), a 
    ld a, LCD_EN ; Set E bit to send instruction
    ld (hl), a 
    ld a, 0x00 ; Clear RS/RW/E bits
    ld (hl), a ; Clear RS/RW/E bits
   
    ret

lcd_setup:
    ld a, LCD_MODE
    call lcd_instruction
    
    ld a, LCD_DON
    call lcd_instruction

    ld a, LCD_SHIFT
    call lcd_instruction

    ld a, LCD_CLEAR
    call lcd_instruction

    ret

; ; String addr goes to HL Pair
; puts:
;     push ix
;     ; push a
;     0$:
;         ; ld a, (hl + ix)
;     cp 0x00
;     jp z, 1
;         
;     ; TODO: Print characters here
;     jp 0
;     1$:
;     ; pop a
;     pop ix
;     ret

main:
    call lcd_setup
    
    halt

.org 0x0800
