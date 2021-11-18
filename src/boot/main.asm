global start
extern long_mode_start

section .text           ; code section
bits 32                 ; 32-bit mode


start:
    mov esp, stack_top  ; stack pointer

    call check_multiboot
    call check_cpuid
    call check_long_mode

    call setup_page_tables
    call enable_paging

    lgdt [gdt64.pointer]
    jmp gdt64.code_segment: long_mode_start

    ; the two lines below are now redundant and not executed,
    ; but they are kept for the sake of completeness
    
    mov dword [0xb8000], 0x2f4b2f4f ; print "OK"
    
    hlt


check_multiboot:
    cmp eax, 0x36d76289 ; multiboot magic number
    jne .no_multiboot
    
    ret

.no_multiboot:
    mov al, "M"         ; error code to display
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
    mov al, "C"         ; error code to display
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
    mov al, "L"         ; error code to display
    jmp error


setup_page_tables:
    mov eax, page_table_l3
    or eax, 0b11        ; set present and writable bits of page table flag
    mov [page_table_l4], eax

    mov eax, page_table_l2
    or eax, 0b11        ; set present and writable bits of page table flag
    mov [page_table_l3], eax

    mov ecx, 0          ; counter

.loop:
    mov eax, 0x200000   ; 2MB
    mul ecx
    or eax, 0b10000011  ; set present, writable, huge page bits
    mov [page_table_l2 + ecx * 8], eax

    inc ecx             ; increment counter
    cmp ecx, 512        ; check if the whole page table has been set
    jne .loop           ; if not, continue

    ret


enable_paging:
    ; pass the page table address to cpu
    mov eax, page_table_l4
    mov cr3, eax        ; the cpu looks for page table address in cr3

    ; enable Physical Address Extension for 64-bit paging
    mov eax, cr4
    or eax, 1 << 5      ; PAE bit
    mov cr4, eax

    ; enable long mode
    mov ecx, 0xC0000080 ; magic number for long mode
    rdmsr               ; read Model Specific Register
    or eax, 1 << 8      ; set long mode bit
    wrmsr               ; write Model Specific Register

    ; enable paging
    mov eax, cr0
    or eax, 1 << 31     ; set paging bit
    mov cr0, eax

    ret


error:
    ; print "ERR: X" where X is the error code stored in al
    mov dword [0xb8000], 0x4f524f45
    mov dword [0xb8004], 0x4f3a4f52
    mov dword [0xb8008], 0x4f204f20
    mov byte  [0xb800a], al ; error code X
    
    hlt


section .bss            ; for uninitialized statically allocated variables
align 4096              ; align to 4KB
page_table_l4:
    resb 4096           ; reserve 4KB for L4 page table
page_table_l3:
    resb 4096           ; reserve 4KB for L3 page table
page_table_l2:
    resb 4096           ; reserve 4KB for L2 page table
stack_end:
    resb 4096 * 4       ; 16KB
stack_top:


section .rodata         ; read-only data section
gdt64:                  ; 64-bit Global Descriptor Table
    dq 0                ; zero entry
.code_segment: equ $ - gdt64 ; offset of code segment
    ; executable flag | descriptor type 1 | present flag | 64-bit flag
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53) ; code segment
.pointer:
    dw $ - gdt64 - 1    ; length of GDT - 1
    dq gdt64            ; address of GDT
