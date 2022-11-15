%include "macros.inc"

section .text
    global _start

    _start:
        fild dword [a]
        fsqrt
        fist dword [b]
        mov eax, [b]
        printd
        new_line
        EXIT 0
        
    

section .data
    a dw 121

section .bss
    result resb 1
    b resw 1