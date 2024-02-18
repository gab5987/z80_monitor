.include "layout.inc"

.section ".start", "acrx"
.org 0x0000
; Application entry point and reset vector.
__start__:
    ; Sets up the RAM stack pointer
    ld sp, RAM_END

    ; Sets up the IO expansor
    ld hl, IO_ADDR_SP
    ld (hl), IO_CONTROL_WORD_0

    ei
    im 1

    jp main

.org INT_ADDR
; Interrupt vector, the cpu will reset to this location once
; a Maskable Interrupt occours.
__int_vector:
    di
    call lcd_return_home

    ld a, (counter)
    inc a
    ld (counter), a
    add a, '0'
     
    ld b, a
    call put_char
    
    ei
    reti

.org NMI_ADDR
; Non Maskable Interrupt vector, the cpu will reset to this 
;location once a Non Maskable Interrupt occours.
__nmi_vector:
    retn

.section .text

; Awaits for the LCD to finish its instruction cycle
lcd_wait:
    push af
    ld hl, IO_ADDR_SP
    ld (hl), IO_CONTROL_WORD_8

    ld hl, LCD_CFG_ADDR
    ld de, LCD_DATA_ADDR
    
    __lcd_busy$:
        ld (hl), LCD_RW
        ld (hl), LCD_RW | LCD_EN
        ld a, (de)
       
        bit LCD_BUSY_FLAG_BIT, a
        jp nz, __lcd_busy$
    
    ld (hl), LCD_RW

    ; TODO: Actually read the value from the SP and store it to return with the same config
    ld hl, IO_ADDR_SP
    ld (hl), IO_CONTROL_WORD_0
    
    pop af
    ret

; Sends a instruction to the LCD display.
;
; Param:
; - Expects instruction stored in the B register.
lcd_instruction:
    push hl
    call lcd_wait

    ld hl, LCD_DATA_ADDR
    ld (hl), b

    ld hl, LCD_CFG_ADDR
    ld (hl), 0x00   ; Clear RS/RW/E bits
    ld (hl), LCD_EN ; Set E bit to send instruction
    ld (hl), 0x00   ; Clear RS/RW/E bits

    pop hl
    ret

; Sends a character to the display.
;
; Param:
; - Expects the character stored in the B register.
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

; Initializes the LCD display.
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

; Returns the display cursor to the home location
lcd_return_home:
    push bc

    ld b, LCD_HOME
    call lcd_instruction

    pop bc
    ret


; Prints a whole zero terminated string onto the display.
; This function does not counts for display overflows!
;
; Param:
; - Expects a pointer to a string in the HL pair.
puts:
    push af
    push bc
    
    __print_n_char$: 
        ld a, (hl)
        or a
        jp z, __exit$

        ld b, a
        call put_char

        inc hl
        jp __print_n_char$
    
    __exit$:
    pop bc
    pop af
    ret

; Main application function.
main:
    call lcd_setup

    ; ld hl, hello
    ; call puts

    ld a, 0
    ld (counter), a

    loop:
        jp loop

    halt

.section .rodata
hello:
    .ascii "Hello, World!", 0

.section .bss
    .bss counter, 1

