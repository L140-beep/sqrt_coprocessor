%macro EXIT 1
    mov eax, 1
    mov ebx, %1
    int 0x80
%endmacro

%macro putchar 1
    pushd
    jmp %%work
    %%char db %1
%%work:
    mov eax, 4
    mov ebx, 1
    mov ecx, %%char
    mov edx, 1
    int 0x80
    popd
%endmacro

%macro const_print 1
    pushd
    jmp %%print 
    %%str db %1
    %%len equ $ - %%str
%%print:  
    mov eax, 4
    mov ebx, 1
    mov ecx, %%str
    mov edx, %%len
    int 0x80
    popd
%endmacro

%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    popd
%endmacro

%macro printd 0
    pushd
    mov bx, 0
    mov ecx, 10
    %%_divide:
    mov edx, 0
    div ecx
    push dx
    inc bx
    test eax, eax
    jnz %%_divide
    %%_digit:
    pop ax
    add ax, '0'
    mov [result], ax
    print 1, result
    dec bx
    cmp bx, 0
    jg %%_digit
    popd
%endmacro

%macro pushd 0
    push eax
    push ebx
    push ecx
    push edx
%endmacro

%macro popd 0
    pop edx
    pop ecx
    pop ebx
    pop eax
%endmacro

%macro new_line 0
    putchar 0xA
    putchar 0xD
%endmacro

%macro decimal 2
    pushd
    mov eax, %1
    mov ebx, 10
    mul ebx
    mov ecx, %2
    div ecx
    pop edx
    pop ecx
    pop ebx
%endmacro