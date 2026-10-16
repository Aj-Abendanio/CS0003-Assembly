section .data
    clear db 27,'[2J',27,'[H'
    clearlen equ $-clear
    menu db '-----------------------------------',10
         db 'MENU',10
         db '[A]dd',10
         db '[S]ubtract',10
         db '[M]ultiply',10
         db '[D]ivide',10
         db '-----------------------------------',10
    menulen equ $-menu
    askchoice db 'Enter your choice: '
    askchoicelen equ $-askchoice
    ask1 db 'Enter first number: '
    ask1len equ $-ask1
    ask2 db 'Enter second number: '
    ask2len equ $-ask2
    summsg db 'The sum is '
    sumlen equ $-summsg
    diffmsg db 'The difference is '
    difflen equ $-diffmsg
    prodmsg db 'The product is '
    prodlen equ $-prodmsg
    quotmsg db 'The quotient is '
    quotlen equ $-quotmsg
    badchoice db 'Invalid choice.',10
    badchoicelen equ $-badchoice
    badnum db 'Invalid number. Please use integer digits.',10
    badnumlen equ $-badnum
    zeromsg db 'Cannot divide by zero.',10
    zerolen equ $-zeromsg
    trymsg db 'Do you want to try again (Y/N): '
    trylen equ $-trymsg
    byemsg db 'Program terminated.',10
    byelen equ $-byemsg

section .bss
    choice resb 8
    buf1 resb 33
    buf2 resb 33
    chr resb 1
    len1 resd 1
    len2 resd 1
    val1 resd 1
    val2 resd 1
    result resd 1
    outbuf resb 16
    negflag resb 1

section .text
    global _start

_start:
menu_loop:
    mov ecx,menu
    mov edx,menulen
    call show

    mov ecx,askchoice
    mov edx,askchoicelen
    call show
    mov ecx,choice
    mov edx,7
    call readln

    cmp byte [choice],'A'
    je choose_add
    cmp byte [choice],'a'
    je choose_add
    cmp byte [choice],'S'
    je choose_sub
    cmp byte [choice],'s'
    je choose_sub
    cmp byte [choice],'M'
    je choose_mul
    cmp byte [choice],'m'
    je choose_mul
    cmp byte [choice],'D'
    je choose_div
    cmp byte [choice],'d'
    je choose_div

    mov ecx,badchoice
    mov edx,badchoicelen
    call show
    jmp try_again

choose_add:
    call get_numbers
    test eax,eax
    jnz invalid_number
    call add_num
    jmp try_again

choose_sub:
    call get_numbers
    test eax,eax
    jnz invalid_number
    call sub_num
    jmp try_again

choose_mul:
    call get_numbers
    test eax,eax
    jnz invalid_number
    call mul_num
    jmp try_again

choose_div:
    call get_numbers
    test eax,eax
    jnz invalid_number
    call div_num
    jmp try_again

invalid_number:
    mov ecx,badnum
    mov edx,badnumlen
    call show
    jmp try_again

try_again:
    mov ecx,trymsg
    mov edx,trylen
    call show
    mov ecx,choice
    mov edx,7
    call readln

    cmp byte [choice],'Y'
    je retry_menu
    cmp byte [choice],'y'
    je retry_menu

    mov ecx,byemsg
    mov edx,byelen
    call show
    mov eax,1
    xor ebx,ebx
    int 0x80

retry_menu:
    mov ecx,clear
    mov edx,clearlen
    call show
    jmp menu_loop

get_numbers:
    mov ecx,ask1
    mov edx,ask1len
    call show
    mov ecx,buf1
    mov edx,32
    call readln
    mov [len1],eax
    mov ecx,buf1
    mov edx,[len1]
    call parse_int
    jc .bad
    mov [val1],eax

    mov ecx,ask2
    mov edx,ask2len
    call show
    mov ecx,buf2
    mov edx,32
    call readln
    mov [len2],eax
    mov ecx,buf2
    mov edx,[len2]
    call parse_int
    jc .bad
    mov [val2],eax

    xor eax,eax
    ret

.bad:
    mov eax,1
    ret

add_num:
    mov eax,[val1]
    add eax,[val2]
    mov [result],eax
    mov ecx,summsg
    mov edx,sumlen
    call show
    mov eax,[result]
    call print_num
    ret

sub_num:
    mov eax,[val1]
    sub eax,[val2]
    mov [result],eax
    mov ecx,diffmsg
    mov edx,difflen
    call show
    mov eax,[result]
    call print_num
    ret

mul_num:
    mov eax,[val1]
    imul eax,[val2]
    mov [result],eax
    mov ecx,prodmsg
    mov edx,prodlen
    call show
    mov eax,[result]
    call print_num
    ret

div_num:
    cmp dword [val2],0
    je .zero
    mov eax,[val1]
    cdq
    idiv dword [val2]
    mov [result],eax
    mov ecx,quotmsg
    mov edx,quotlen
    call show
    mov eax,[result]
    call print_num
    ret

.zero:
    mov ecx,zeromsg
    mov edx,zerolen
    call show
    ret

show:
    mov eax,4
    mov ebx,1
    int 0x80
    ret

readln:
    mov edi,ecx
    mov esi,edx
    xor ebp,ebp

.read_char:
    mov eax,3
    xor ebx,ebx
    mov ecx,chr
    mov edx,1
    int 0x80
    cmp eax,1
    jne .done
    cmp byte [chr],10
    je .done
    cmp ebp,esi
    jae .read_char
    mov al,[chr]
    mov [edi+ebp],al
    inc ebp
    jmp .read_char

.done:
    mov byte [edi+ebp],0
    mov eax,ebp
    ret

parse_int:
    mov esi,ecx
    mov ecx,edx
    xor eax,eax
    mov ebx,1
    test ecx,ecx
    jz .bad
    cmp byte [esi],'-'
    jne .digits
    mov ebx,-1
    inc esi
    dec ecx
    jz .bad

.digits:
    movzx edx,byte [esi]
    cmp edx,'0'
    jb .bad
    cmp edx,'9'
    ja .bad
    sub edx,'0'
    imul eax,eax,10
    add eax,edx
    inc esi
    dec ecx
    jnz .digits
    imul eax,ebx
    clc
    ret

.bad:
    stc
    ret

print_num:
    mov byte [negflag],0
    mov edi,outbuf+15
    mov byte [edi],10
    dec edi
    cmp eax,0
    jge .digits_start
    neg eax
    mov byte [negflag],1

.digits_start:
    mov ebx,10

.digits:
    xor edx,edx
    div ebx
    add dl,'0'
    mov [edi],dl
    dec edi
    test eax,eax
    jnz .digits
    cmp byte [negflag],1
    jne .write
    mov byte [edi],'-'
    dec edi

.write:
    lea ecx,[edi+1]
    mov edx,outbuf+16
    sub edx,ecx
    call show
    ret
