; Georgette Eatery - Food Ordering System
; ABENDANIO

%macro print_text 2
    mov ecx, %1
    mov edx, %2
    call print_proc
%endmacro

section .data
    menu db 10, '+----------------------------------------------------+', 10
         db '|       UwU        GEORGETTE EATERY        UwU       |', 10
         db '|                     FOOD MENU                      |', 10
         db '+----------------------------------------------------+', 10
         db '|  A. Rice      - Plain Rice              Php  5.00  |', 10
         db '|  B. Rice      - Java Rice               Php 10.00  |', 10
         db '|  C. Ulam 1    - Fish                    Php 35.00  |', 10
         db '|  D. Ulam 2    - Pork                    Php 50.00  |', 10
         db '|  E. Ulam 3    - Vegetables              Php 20.00  |', 10
         db '|  F. Dessert   - Saging con yelo         Php 60.00  |', 10
         db '+----------------------------------------------------+', 10
         db 'Enter your choice (A-F): '
    menulen equ $-menu

    order_msg db 10, '+------------------- ORDER CONFIRMED ------------------+', 10
              db 'You ordered: '
    order_msg_len equ $-order_msg

    item_a db 'Plain Rice: Php 5.00', 10
    item_alen equ $-item_a
    item_b db 'Java Rice: Php 10.00', 10
    item_blen equ $-item_b
    item_c db 'Fish: Php 35.00', 10
    item_clen equ $-item_c
    item_d db 'Pork: Php 50.00', 10
    item_dlen equ $-item_d
    item_e db 'Vegetables: Php 20.00', 10
    item_elen equ $-item_e
    item_f db 'Saging con yelo: Php 60.00', 10
    item_flen equ $-item_f

    again_msg db 10, 'Do you want to order again? [Y/N]: '
    again_len equ $-again_msg

    invalid_msg db 10, 'Invalid choice. Please enter A, B, C, D, E, or F.', 10
    invalid_len equ $-invalid_msg

    invalid_again db 'Please enter Y or N.', 10
    invalid_again_len equ $-invalid_again

    thanks_msg db 10, '+------------------------------------------------------+', 10
               db '|             Thank you! Please come again!            |', 10
               db '+------------------------------------------------------+', 10
    thanks_len equ $-thanks_msg

    receipt_title db 'GEORGETTE EATERY', 10
                  db 'ORDER RECEIPT', 10
                  db '------------------------------------------------------', 10
    receipt_title_len equ $-receipt_title

    receipt_screen db 10, '------------------ FINAL RECEIPT ---------------------', 10
    receipt_screen_len equ $-receipt_screen

    file_error db 'Unable to create or open receipt.txt.', 10
    file_error_len equ $-file_error

    file_name db 'receipt.txt', 0

section .bss
    choice resb 8
    answer resb 8
    chr resb 1
    fd resd 1
    dest resd 1
    filebuf resb 1024

section .text
    global _start

_start:
    mov eax, 5
    mov ebx, file_name
    mov ecx, 577
    mov edx, 420
    int 0x80
    test eax, eax
    js open_fail

    mov [fd], eax
    mov [dest], eax
    print_text receipt_title, receipt_title_len
    mov dword [dest], 1

menu_loop:
    print_text menu, menulen
    mov ecx, choice
    mov edx, 7
    call readln

    cmp byte [choice], 'a'
    jb check_choice
    cmp byte [choice], 'z'
    ja check_choice
    sub byte [choice], 32

check_choice:
    cmp byte [choice], 'A'
    je order_a
    cmp byte [choice], 'B'
    je order_b
    cmp byte [choice], 'C'
    je order_c
    cmp byte [choice], 'D'
    je order_d
    cmp byte [choice], 'E'
    je order_e
    cmp byte [choice], 'F'
    je order_f

    print_text invalid_msg, invalid_len
    jmp menu_loop

order_a:
    print_text order_msg, order_msg_len
    print_text item_a, item_alen
    mov eax, [fd]
    mov [dest], eax
    print_text item_a, item_alen
    mov dword [dest], 1
    jmp ask_again

order_b:
    print_text order_msg, order_msg_len
    print_text item_b, item_blen
    mov eax, [fd]
    mov [dest], eax
    print_text item_b, item_blen
    mov dword [dest], 1
    jmp ask_again

order_c:
    print_text order_msg, order_msg_len
    print_text item_c, item_clen
    mov eax, [fd]
    mov [dest], eax
    print_text item_c, item_clen
    mov dword [dest], 1
    jmp ask_again

order_d:
    print_text order_msg, order_msg_len
    print_text item_d, item_dlen
    mov eax, [fd]
    mov [dest], eax
    print_text item_d, item_dlen
    mov dword [dest], 1
    jmp ask_again

order_e:
    print_text order_msg, order_msg_len
    print_text item_e, item_elen
    mov eax, [fd]
    mov [dest], eax
    print_text item_e, item_elen
    mov dword [dest], 1
    jmp ask_again

order_f:
    print_text order_msg, order_msg_len
    print_text item_f, item_flen
    mov eax, [fd]
    mov [dest], eax
    print_text item_f, item_flen
    mov dword [dest], 1
    jmp ask_again

ask_again:
    print_text again_msg, again_len
    mov ecx, answer
    mov edx, 7
    call readln

    cmp byte [answer], 'y'
    je continue_order
    cmp byte [answer], 'Y'
    je continue_order
    cmp byte [answer], 'n'
    je finish_order
    cmp byte [answer], 'N'
    je finish_order

    print_text invalid_again, invalid_again_len
    jmp ask_again

continue_order:
    jmp menu_loop

finish_order:
    print_text thanks_msg, thanks_len

    mov eax, 6
    mov ebx, [fd]
    int 0x80

    print_text receipt_screen, receipt_screen_len
    mov eax, 5
    mov ebx, file_name
    xor ecx, ecx
    xor edx, edx
    int 0x80
    test eax, eax
    js open_fail
    mov [fd], eax
    mov dword [dest], 1

read_receipt:
    mov eax, 3
    mov ebx, [fd]
    mov ecx, filebuf
    mov edx, 1024
    int 0x80
    cmp eax, 0
    jle close_receipt
    mov ecx, filebuf
    mov edx, eax
    call print_proc
    jmp read_receipt

close_receipt:
    mov eax, 6
    mov ebx, [fd]
    int 0x80
    jmp exit_program

open_fail:
    mov dword [dest], 1
    print_text file_error, file_error_len

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_proc:
    push ebx
    mov eax, 4
    mov ebx, [dest]
    int 0x80
    pop ebx
    ret

readln:
    mov edi, ecx
    mov esi, edx
    xor ebp, ebp

read_char:
    mov eax, 3
    xor ebx, ebx
    mov ecx, chr
    mov edx, 1
    int 0x80
    cmp eax, 1
    jne read_done
    cmp byte [chr], 10
    je read_done
    cmp ebp, esi
    jae read_char
    mov al, [chr]
    mov [edi+ebp], al
    inc ebp
    jmp read_char

read_done:
    mov byte [edi+ebp], 0
    mov eax, ebp
    ret
