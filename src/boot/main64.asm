global long_mode_start
extern kernel_main

section .text           ; code section
bits 64                 ; 64-bit mode


long_mode_start:
    ; initialise all data segment registers to 0
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call kernel_main    ; entry point for the C kernel code
    
    hlt
