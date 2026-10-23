; Problem 2 - Balanced Brackets Validator (BASCO)

section .data
    prompt db "Enter an expression: "
    prompt_len equ $ - prompt

    answer db "Balanced: 0", 10
    answer_len equ $ - answer

section .bss
    input resb 128

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 127
    int 0x80

    mov ebp, eax
    mov byte [input + ebp], 0

    call check

    add al, '0'
    mov [answer + 10], al

    mov eax, 4
    mov ebx, 1
    mov ecx, answer
    mov edx, answer_len
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80


check:
    mov esi, input
    xor ecx, ecx

scan:
    mov al, [esi]

    cmp al, 0
    je done

    cmp al, '('
    je open

    cmp al, ')'
    je close

    inc esi
    jmp scan


open:
    push dword '('
    inc ecx
    inc esi
    jmp scan


close:
    cmp ecx, 0
    je bad

    pop edx
    dec ecx
    inc esi
    jmp scan


done:
    cmp ecx, 0
    jne bad

    mov eax, 1
    ret


bad:
    cmp ecx, 0
    je zero

clear:
    pop edx
    dec ecx
    cmp ecx, 0
    jne clear

zero:
    xor eax, eax
    ret
