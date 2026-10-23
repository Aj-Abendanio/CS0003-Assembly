; Problem 3 - Multi-Register State Preservation & Arithmetic Subroutine (BASCO)

section .data
    menu    db 10, "========== OPERATION MENU ==========", 10
            db "1. Multiplication and Addition", 10
            db "2. Division and Accumulation", 10
            db "3. Subtraction and Scaling", 10
            db "4. Bitwise AND and OR", 10
            db "5. Modulo and Division", 10
            db "6. Zero-state Arithmetic", 10
            db "====================================", 10, 0

    opmsg   db "Choose operation (1-6): ", 0
    eaxmsg  db "Enter EAX: ", 0
    ebxmsg  db "Enter EBX: ", 0
    ecxmsg  db "Enter ECX: ", 0
    edxmsg  db "Enter EDX: ", 0

    result  db 10, "Results produced by calculate_foo:", 10, 0
    eaxout  db "EAX = ", 0
    ebxout  db "EBX = ", 0
    ecxout  db "ECX = ", 0
    edxout  db "EDX = ", 0
    espout  db "Final ESP offset = ", 0
    line    db 10, 0

    badop   db "Invalid operation. Please choose 1-6.", 10, 0
    baddiv  db "Divisor inputs cannot be zero for this operation.", 10, 0

    input   times 32 db 0
    op      dd 0
    eaxin   dd 0
    ebxin   dd 0
    ecxin   dd 0
    edxin   dd 0
    eaxres  dd 0
    ebxres  dd 0
    ecxres  dd 0
    edxres  dd 0
    before  dd 0
    offset  dd 0

section .text
    global _start

_start:
    mov ecx, menu
    call print

    mov ecx, opmsg
    call print
    call read

    cmp eax, 1
    jb wrong

    cmp eax, 6
    ja wrong

    mov [op], eax

    mov ecx, eaxmsg
    call print
    call read
    mov [eaxin], eax

    mov ecx, ebxmsg
    call print
    call read
    mov [ebxin], eax

    mov ecx, ecxmsg
    call print
    call read
    mov [ecxin], eax

    mov ecx, edxmsg
    call print
    call read
    mov [edxin], eax

    cmp dword [op], 2
    je check

    cmp dword [op], 5
    jne init

    cmp dword [ebxin], 0
    je divide

    cmp dword [edxin], 0
    je divide

    jmp init

check:
    cmp dword [ebxin], 0
    je divide

init:
    mov eax, [eaxin]
    mov ebx, [ebxin]
    mov ecx, [ecxin]
    mov edx, [edxin]

    mov [before], esp

    call calculate

    mov eax, esp
    sub eax, [before]
    mov [offset], eax

    mov ecx, result
    call print

    mov ecx, eaxout
    call print
    mov eax, [eaxres]
    call number

    mov ecx, ebxout
    call print
    mov eax, [ebxres]
    call number

    mov ecx, ecxout
    call print
    mov eax, [ecxres]
    call number

    mov ecx, edxout
    call print
    mov eax, [edxres]
    call number

    mov ecx, espout
    call print
    mov eax, [offset]
    call number

    mov eax, 1
    xor ebx, ebx
    int 0x80

wrong:
    mov ecx, badop
    call print

    mov eax, 1
    mov ebx, 1
    int 0x80

divide:
    mov ecx, baddiv
    call print

    mov eax, 1
    mov ebx, 1
    int 0x80

calculate:
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov esi, [op]

    cmp esi, 1
    je muladd

    cmp esi, 2
    je divadd

    cmp esi, 3
    je subscale

    cmp esi, 4
    je logic

    cmp esi, 5
    je moddiv

    jmp zero

muladd:
    imul ebx
    add ecx, edx
    jmp store

divadd:
    xor edx, edx
    div ebx
    add ecx, [edxin]
    jmp store

subscale:
    sub eax, ebx
    imul ecx, edx
    jmp store

logic:
    and eax, ebx
    or ecx, edx
    jmp store

moddiv:
    xor edx, edx
    div ebx

    mov [eaxres], edx

    xor edx, edx
    mov eax, ecx
    div dword [edxin]

    mov ecx, eax
    mov eax, [eaxres]

    jmp store

zero:
    add eax, edx
    sub ebx, edx
    imul ecx, edx
    xor edx, edx

store:
    mov [eaxres], eax
    mov [ebxres], ebx
    mov [ecxres], ecx
    mov [edxres], edx

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

print:
    push eax
    push ebx
    push edx
    push esi

    mov esi, ecx
    xor edx, edx

length:
    cmp byte [esi + edx], 0
    je write

    inc edx
    jmp length

write:
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80

    pop esi
    pop edx
    pop ebx
    pop eax

    ret

read:
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 32
    int 0x80

    mov esi, input
    xor eax, eax

parse:
    mov bl, [esi]

    cmp bl, 10
    je done

    cmp bl, 0
    je done

    sub bl, '0'
    imul eax, 10

    movzx ebx, bl
    add eax, ebx

    inc esi
    jmp parse

done:
    ret

number:
    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov esi, input + 31
    mov byte [esi], 10
    dec esi

    xor ecx, ecx
    mov ebx, 10

digits:
    xor edx, edx
    div ebx

    add dl, '0'
    mov [esi], dl
    dec esi

    inc ecx

    test eax, eax
    jnz digits

    inc esi

    mov eax, 4
    mov ebx, 1
    mov edx, ecx
    mov ecx, esi
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, line
    mov edx, 1
    int 0x80

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret
