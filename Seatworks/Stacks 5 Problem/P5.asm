; Problem 5 - Reverse Array and Sum (ABENDANIO)

section .data
    prompt db "Enter 5 integers, one per line:", 10
    plen equ $ - prompt
    revmsg db "Reversed: "
    rlen equ $ - revmsg
    summsg db "Sum: "
    slen equ $ - summsg
    space db " "
    nl db 10

section .bss
    inp resb 32
    dst resd 5
    sum resd 1
    nbuf resb 12

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, plen
    int 0x80

    mov edi, 5

.read_loop:
    mov eax, 3
    mov ebx, 0
    mov ecx, inp
    mov edx, 32
    int 0x80

    xor eax, eax
    mov esi, inp

.convert:
    movzx edx, byte [esi]
    cmp dl, 10
    je .save_num
    cmp dl, 13
    je .save_num
    test dl, dl
    jz .save_num

    sub edx, '0'
    cmp edx, 9
    ja .save_num

    imul eax, eax, 10
    add eax, edx
    inc esi
    jmp .convert

.save_num:
    push eax
    dec edi
    jnz .read_loop

    xor eax, eax
    xor ecx, ecx

.pop_loop:
    pop ebx
    mov [dst + ecx*4], ebx
    add eax, ebx
    inc ecx
    cmp ecx, 5
    jb .pop_loop

    mov [sum], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, revmsg
    mov edx, rlen
    int 0x80

    xor ecx, ecx

.print_arr:
    mov eax, [dst + ecx*4]
    call print_num
    inc ecx
    cmp ecx, 5
    je .arr_done

    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80
    pop ecx
    jmp .print_arr

.arr_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, summsg
    mov edx, slen
    int 0x80

    mov eax, [sum]
    call print_num

    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_num:
    pushad
    mov edi, nbuf + 11
    xor ecx, ecx
    mov ebx, 10

.num_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    inc ecx
    test eax, eax
    jnz .num_loop

    inc edi
    mov edx, ecx
    mov ecx, edi
    mov ebx, 1
    mov eax, 4
    int 0x80

    popad
    ret
