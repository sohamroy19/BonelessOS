global start

section .text   ; code section
bits 32         ; 32-bit mode

start:
    mov esp, stack_top

    call check_multiboot
    call check_cpuid
    call check_long_mode

    ; print "OK"
    mov dword [0xb8000], 0x2f4b2f4f
    hlt

check_multiboot:
    ; check if eax holds the multiboot magic number
    cmp eax, 0x36d76289
    jne .no_multiboot
    ret
.no_multiboot:
    mov al, "M" ; error code to display
    jmp error

check_cpuid:
    pushfd              ; push flags register to stack
    pop eax             ; eax holds flags register
    mov ecx, eax        ; save original flags register
    xor eax, 1 << 21    ; flip bit 21 (cpuid bit)
    push eax            ; push eax to stack
    popfd               ; pop flags register from stack
    ; if the cpuid flag is now restored, cpuid is not available
    
    pushfd              ; push flags register to stack 
    pop eax             ; eax holds flags register
    push ecx            ; push original flags register to stack
    popfd               ; restore original flags register
    cmp eax, ecx        ; if equal, flag was restored, cpuid is not available
    je .no_cpuid

    ret
.no_cpuid:
    mov al, "C" ; error code to display
    jmp error

check_long_mode:
    mov eax, 0x80000000 ; check if cpu supports long mode
    cpuid               ; increases eax if extended processor info is supported
    cmp eax, 0x80000001
    jb .no_long_mode    ; no extended processor info = no long mode support

    mov eax, 0x80000001 ; extended processor info
    cpuid               ; if lm bit is set in edx, long mode is supported
    test edx, 1 << 29   ; test bit 29 (long mode bit)
    jz .no_long_mode

    ret
.no_long_mode:
    mov al, "L" ; error code to display
    jmp error

error:
    ; print "ERR: X" where X is the error code
    mov dword [0xb8000], 0x4f524f45
    mov dword [0xb8004], 0x4f3a4f52
    mov dword [0xb8008], 0x4f204f20
    mov byte  [0xb800a], al ; error code X
    hlt

section .bss ; for uninitialized statically allocated variables
stack_end:
    resb 4096 * 4 ; 16 KB
stack_top:
