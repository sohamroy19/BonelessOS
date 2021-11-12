global long_mode_start

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

    ; print "OK"
    mov dword [0xb8000], 0x2f4b2f4f
    
    hlt