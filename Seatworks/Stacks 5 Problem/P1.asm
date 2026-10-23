; Problem 1 - Reverse a Null-Terminated String (BASCO)

section .data
    ask     db "Enter a string: "
    asksz   equ $ - ask
 
    show    db "Reversed string: "
    showsz  equ $ - show
 
    nl      db 10
 
section .bss
    text    resb 256
    count   resd 1
 
section .text
    global _start
 
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, ask
    mov edx, asksz
    int 0x80
 
    mov eax, 3
    mov ebx, 0
    mov ecx, text
    mov edx, 255
    int 0x80
 
    cmp eax, 0
    jle quit
 
    mov edx, eax
 
    cmp byte [text + edx - 1], 10
    jne ready
 
    dec edx
 
ready:
    mov byte [text + edx], 0
    mov [count], edx
 
    mov esi, text
    call reverse
 
    mov eax, 4
    mov ebx, 1
    mov ecx, show
    mov edx, showsz
    int 0x80
 
    mov eax, 4
    mov ebx, 1
    mov ecx, text
    mov edx, [count]
    int 0x80
 
    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80
 
quit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
 
reverse:
    mov edi, esi
    xor ecx, ecx
 
pushchars:
    movzx eax, byte [esi]
    test al, al
    jz popchars
 
    push eax
    inc esi
    inc ecx
    jmp pushchars
 
popchars:
    test ecx, ecx
    jz finish
 
take:
    pop eax
    mov [edi], al
    inc edi
    dec ecx
    jnz take
 
finish:
    mov byte [edi], 0
    ret
