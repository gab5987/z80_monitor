MEMORY
{
    ROM (rx) : ORIGIN = 0x0000, LENGTH = 0x0800
    RAM (rwa) : ORIGIN = 0x3000, LENGTH = 0x0800

    /* PERIPHERALS (rw) : ORIGIN = 0x1000, LENGTH = 0x0800 */
}

SECTIONS
{ 
    .start : {
        . = 0x0000;
        *(.start);
    } > ROM

    ENTRY(start)

    .text : { *(.text) } > ROM
    PROVIDE(_etext = .);
    
    .rodata : { *(.rodata) } > ROM

    .fill : {
        . = LENGTH(ROM) - 0x01;
        BYTE(0x76); /* Security HALT */
    } > ROM

    .data : { *(.data) } > RAM
    .bss : { *(.bss) } > RAM
}

