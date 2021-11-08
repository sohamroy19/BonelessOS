global start

section .text
bits 32 ; 32-bit mode
start:
    ; print "OK"
    mov dword [0xb8000], 0x2f4b2f4f
    hlt
