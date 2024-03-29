.equ RAM_ADDR, 0b0011000000000000
.equ RAM_END, RAM_ADDR | 0x7fd

.equ IO_ADDR, 0b0010100000000000
.equ IO_ADDR_PA, IO_ADDR | 0b0000
.equ IO_ADDR_PB, IO_ADDR | 0b0001
.equ IO_ADDR_PC, IO_ADDR | 0b0010
.equ IO_ADDR_SP, IO_ADDR | 0b0011

.equ IO_CONTROL_WORD_0, 0b10000000
.equ IO_CONTROL_WORD_2, 0b10000010
.equ IO_CONTROL_WORD_5, 0b10001001
.equ IO_CONTROL_WORD_8, 0b10010000

.equ IO_DATA_ALL_OUT, IO_CONTROL_WORD_0 

.equ INT_ADDR, 0x0038
.equ NMI_ADDR, 0x0066

.equ LCD_DATA_ADDR, IO_ADDR_PA
.equ LCD_CFG_ADDR, IO_ADDR_PC
.equ LCD_RS, 0b10000000
.equ LCD_RW, 0b01000000
.equ LCD_EN, 0b00100000
.equ LCD_MODE, 0b00111000  ; 8-bit mode; 2-line display; 5x8 font
.equ LCD_DON, 0b00001110   ; Display on; cursor on; blink off
.equ LCD_SHIFT, 0b00000110 ; Increment and shift cursor; don't shift display
.equ LCD_CLEAR, 0b00000001 ; Clear display
.equ LCD_HOME, 0b00000010 ; Sets display cursor to 0x00
.equ LCD_BUSY_FLAG, 0b10000000
.equ LCD_BUSY_FLAG_BIT, 7 ; 7th bit of the data
