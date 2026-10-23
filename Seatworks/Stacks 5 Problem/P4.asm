; Problem 4 - Decimal to Binary (ABENDANIO)

section .data
    prompt db "Enter unsigned 16-bit number: "
    plen equ $ - prompt
    outmsg db "Binary: "
    olen equ $ - outmsg
    nl db 10

section .bss
    inp resb 32
    binbuf resb 17

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, plen
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, inp
    mov edx, 32
    int 0x80

    xor eax, eax
    mov esi, inp

.read_num:
    movzx edx, byte [esi]
    cmp dl, 10
    je .got_num
    cmp dl, 13
    je .got_num
    test dl, dl
    jz .got_num

    sub edx, '0'
    cmp edx, 9
    ja .got_num

    imul eax, eax, 10
    add eax, edx
    inc esi
    jmp .read_num

.got_num:
    test eax, eax
    jnz .divide

    mov byte [binbuf], '0'
    mov edi, binbuf
    inc edi
    jmp .show_bits

.divide:
    xor ecx, ecx
    mov ebx, 2

.div_loop:
    xor edx, edx
    div ebx
    push edx
    inc ecx
    test eax, eax
    jnz .div_loop

    mov edi, binbuf

.pop_loop:
    pop eax
    add al, '0'
    mov [edi], al
    inc edi
    loop .pop_loop

.show_bits:
    mov eax, 4
    mov ebx, 1
    mov ecx, outmsg
    mov edx, olen
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, binbuf
    mov edx, edi
    sub edx, binbuf
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
