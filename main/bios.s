.include "layout.inc"

.section ".start", "acrx"
__start__:
    ; Sets up the RAM stack pointer
    ld sp, RAM_END

    ; Sets up the IO expansor
    ld hl, IO_ADDR_SP
    ld (hl), IO_CONTROL_WORD_0

    ei
    im 1

    ld b, 0x00

    jp main

.section .text
; str:
;     .ascii "0", 0

.org INT_ADDR
_int_response:
    ; di
    ; push af
    ;
    ; ld a, (counter)
    ; inc a
    ; ld (counter), a
    ; add a, 30
    ; ld (str), a
    ;
    ; ld hl, str
    ; call puts
    ;
    ; pop af
    ; ei
    reti

.org NMI_ADDR
_nmi_response:
    retn

; Awaits for the LCD to finish its instruction cycle
lcd_wait:
    push af
    ld hl, IO_ADDR_SP
    ld (hl), IO_CONTROL_WORD_8

    ld hl, LCD_CFG_ADDR
    ld de, LCD_DATA_ADDR

lcd_busy:
    ld (hl), LCD_RW
    ld (hl), LCD_RW | LCD_EN
    ld a, (de)
   
    bit LCD_BUSY_FLAG_BIT, a
    jp nz, lcd_busy
    
    ld (hl), LCD_RW

    ; TODO: Actually read the value from the SP and store it to return with the same config
    ld hl, IO_ADDR_SP
    ld (hl), IO_CONTROL_WORD_0
    
    pop af
    ret

; Expects instruction stored in the b register.
lcd_instruction:
    call lcd_wait

    ld hl, LCD_DATA_ADDR
    ld (hl), b

    ld hl, LCD_CFG_ADDR
    ld (hl), 0x00   ; Clear RS/RW/E bits
    ld (hl), LCD_EN ; Set E bit to send instruction
    ld (hl), 0x00   ; Clear RS/RW/E bits
   
    ret

; Expects thee character to be stored in the b register.
put_char:
    push hl

    call lcd_wait

    ld hl, LCD_DATA_ADDR
    ld (hl), b

    ld hl, LCD_CFG_ADDR
    ld (hl), LCD_RS          ; Set RS; Clear RW/E bits
    ld (hl), LCD_EN | LCD_RS ; Set E bit to send instruction
    ld (hl), LCD_RS          ; Clear E bits

    pop hl
    ret

lcd_setup:
    ld b, LCD_MODE
    call lcd_instruction
    
    ld b, LCD_DON
    call lcd_instruction

    ld b, LCD_SHIFT
    call lcd_instruction

    ld b, LCD_CLEAR
    call lcd_instruction

    ret

; String addr goes to HL Pair
puts:
    push af
    push bc
    
    0$: 
        ld a, (hl)
        or a
        jp z, 1$

        ld b, a
        call put_char

        inc hl
        jp 0$
    1$:

    pop bc
    pop af
    ret

main:
    call lcd_setup

    ld hl, hello
    call puts

    ; loop$:
        ; str:
        ;     .ascii "0", 0
        ; ld a, (str)
        ; add a, 30
        ; ld (str), a
        ;
        ; ld hl, str
        ; call puts
    ; jp loop$
    
    halt

.section .rodata
hello:
    .ascii "Hello, World!", 0

