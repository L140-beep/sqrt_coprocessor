%include "macros.inc"

%macro pow 2
    pushd
    mov eax, %1
    mov ebx, eax
    mov ecx, %2
    dec ecx
    cmp ecx, 0
    jg %%_pow
    jmp %%_exit
    
%%_pow:
    imul eax, ebx
    loop %%_pow

%%_exit:
    pop edx
    pop ebx
    pop ecx
%endmacro

section .text
    global _start

    _start:
        ;вычисляем корень, выделяем из него порядок и мантиссу
        fld dword [num]
        fsqrt
        fxtract
        fstp dword [mantis] ; мантисса
        fistp dword [e] ; порядок

        ;избавляемся от лишних единиц в мантиссе
        mov eax, [mantis]
        and eax, 0x7FFFFF
        const_print "Мантисса: "
        printd
        new_line
        mov [mantis], eax
        mov eax, [e]
        const_print "Порядок: "
        printd
        new_line

;перевод в десятичное число из формата IEEE 754: (-1)^S * 2 ^ E * (1 + M/2^23), S - sign, E - порядок, M - мантисса

        xor eax, eax
        xor ebx, ebx

        ;количество знаков после запятой
        pow dword 10, [perception]
        mov [degree], eax
        mov ebx, [mantis]

        ; fild qword [mantis]
        ; fimul dword [degree]
        ; fistp qword [mantis]

        mov eax, [mantis]
        imul eax, [degree]

        const_print "Домноженная мантисса: "
        printd
        new_line
        mov [mantis], eax
        xor eax, eax
        
        pow dword 2, dword 23
        
        ;eax = 2^23z

        mov ebx, eax
        mov eax, [mantis]
        xor edx, edx
        
        div ebx ;M / 2^23
        const_print "M/2^23 = 0,"
        printd
        new_line
        mov [mantis], eax

        add eax, dword [degree]

        mov ecx, eax
        mov eax, ecx
        xor eax, eax
        pow dword 2, [e]
        printd
        new_line
        mul ebx 

        const_print "Результат до деления: "
        printd
        new_line

        xor ebx, ebx
        mov ebx, [degree]
        div ebx

        const_print "Результат: "
        printd
        const_print ","
        mov eax, edx
        printd
        new_line


        EXIT 0
        
    

section .data
    num dd 110.0
    perception dd 3
section .bss
    degree resb 4
    result resb 1
    mantis resb 6
    e resb 2