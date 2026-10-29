; COR: Input student details, display schedule, compute tuition fee
; ABENDANIO FLAB3

%macro print_text 2
    mov ecx, %1
    mov edx, %2
    call print_proc
%endmacro

section .data
    title db 'CERTIFICATE OF REGISTRATION', 10, 10
    titlelen equ $-title

    pnum db 'Enter Student Number: '
    pnumlen equ $-pnum
    pname db 'Enter Name: '
    pnamelen equ $-pname
    pcollege db 'Enter College: '
    pcollegelen equ $-pcollege
    pprog db 'Enter Program: '
    pproglen equ $-pprog
    pyear db 'Enter Year Level and Term: '
    pyearlen equ $-pyear
    pphone db 'Enter Phone Number: '
    pphonelen equ $-pphone
    paddr db 'Enter Address: '
    paddrlen equ $-paddr
    pclass db 'Enter Classification: '
    pclasslen equ $-pclass

    line db 10, '---------------------------------------------------------------------------------------------------------------------------------', 10
    linelen equ $-line
    inf_title db 'STUDENT INFORMATION', 10
    inf_titlelen equ $-inf_title
    stat db 'Enrollment Status: ENROLLED', 10
    statlen equ $-stat
    lnum db 'Student #: '
    lnumlen equ $-lnum
    lname db 'Name: '
    lnamelen equ $-lname
    lcollege db 'College: '
    lcollegelen equ $-lcollege
    lprog db 'Program: '
    lproglen equ $-lprog
    lyear db 'Year Level: '
    lyearlen equ $-lyear
    lphone db 'Phone: '
    lphonelen equ $-lphone
    laddr db 'Address: '
    laddrlen equ $-laddr
    lclass db 'Classification: '
    lclasslen equ $-lclass

    sched_title db 10, 'CLASS SCHEDULE', 10
    sched_titlelen equ $-sched_title
    schedule db 'Course      Title                                  Section  Units  Days      Time                                      Room', 10
             db 'CCS0021     INFORMATION MANAGEMENT (LEC)            TN22     2      T         16:00:00-18:40:00                         ONLINE', 10
             db 'CCS0021L    INFORMATION MANAGEMENT (LAB)            TN22     1      F         16:00:00-18:50:00                         ONLINE', 10
             db 'CS0001      DISCRETE STRUCTURES 1                   TA21     3      M / TH    15:00:00-16:50:00 / 15:00:00-16:50:00   F710 / F710', 10
             db 'CS0003      COMPUTER SYSTEMS & ARCHITECTURE          TN24     2      F         10:00:00-12:40:00                         ONLINE', 10
             db 'CS0003L     COMPUTER SYSTEMS & ARCHITECTURE (LAB)    TN24     1      TH        10:00:00-12:50:00                         E610', 10
             db 'CS0070      OBJECT ORIENTED PROGRAMMING              TA21     2      T         10:00:00-12:40:00                         ONLINE', 10
             db 'CS0070L     OBJECT ORIENTED PROGRAMMING-LAB          TA21     1      M         10:00:00-12:50:00                         E609', 10
             db 'GED0021     SPECIALIZED ENGLISH PROGRAM 2            TA21     3      M / TH    07:00:00-08:50:00 / 07:00:00-08:50:00   F607 / F607', 10
             db 'GED0055     MATHEMATICAL ANALYSIS                    M553     3      S / W     09:00:00-10:50:00 / 09:00:00-10:50:00   F712 / F712', 10
             db 'GED0081     COLLEGE PHYSICS 1 LECTURE                TN26     2      T         13:00:00-15:40:00                         ONLINE', 10
             db 'GED0081L    COLLEGE PHYSICS 1 LABORATORY             TN26     1      W         13:00:00-15:50:00                         F1003', 10
    schedulelen equ $-schedule

    unit_prompt db 10, 'Enter total units: '
    unit_promptlen equ $-unit_prompt
    tuition_msg db 'Tuition Fee: PHP '
    tuition_msglen equ $-tuition_msg
    invalid_msg db 'Invalid input pls enter digits only.', 10
    invalid_len equ $-invalid_msg
    unit_msg db 'Total Units: '
    unit_msglen equ $-unit_msg

section .bss
    snum resb 40
    name resb 80
    college resb 60
    prog resb 40
    year resb 40
    phone resb 40
    addr resb 100
    class resb 40
    numbuf resb 32
    chr resb 1
    snumlen resd 1
    namelen resd 1
    collegelen resd 1
    proglen resd 1
    yearlen resd 1
    phonelen resd 1
    addrlen resd 1
    classlen resd 1
    numlen resd 1
    units resd 1
    fee resd 1
    outbuf resb 16
    negflag resb 1

section .text
    global _start

_start:
    print_text title, titlelen

    print_text pnum, pnumlen
    mov ecx, snum
    mov edx, 39
    call readln
    mov [snumlen], eax

    print_text pname, pnamelen
    mov ecx, name
    mov edx, 79
    call readln
    mov [namelen], eax

    print_text pcollege, pcollegelen
    mov ecx, college
    mov edx, 59
    call readln
    mov [collegelen], eax

    print_text pprog, pproglen
    mov ecx, prog
    mov edx, 39
    call readln
    mov [proglen], eax

    print_text pyear, pyearlen
    mov ecx, year
    mov edx, 39
    call readln
    mov [yearlen], eax

    print_text pphone, pphonelen
    mov ecx, phone
    mov edx, 39
    call readln
    mov [phonelen], eax

    print_text paddr, paddrlen
    mov ecx, addr
    mov edx, 99
    call readln
    mov [addrlen], eax

    print_text pclass, pclasslen
    mov ecx, class
    mov edx, 39
    call readln
    mov [classlen], eax

    print_text line, linelen
    print_text inf_title, inf_titlelen
    print_text stat, statlen

    print_text lnum, lnumlen
    mov ecx, snum
    mov edx, [snumlen]
    call print_proc
    print_text line, 1

    print_text lname, lnamelen
    mov ecx, name
    mov edx, [namelen]
    call print_proc
    print_text line, 1

    print_text lcollege, lcollegelen
    mov ecx, college
    mov edx, [collegelen]
    call print_proc
    print_text line, 1

    print_text lprog, lproglen
    mov ecx, prog
    mov edx, [proglen]
    call print_proc
    print_text line, 1

    print_text lyear, lyearlen
    mov ecx, year
    mov edx, [yearlen]
    call print_proc
    print_text line, 1

    print_text lphone, lphonelen
    mov ecx, phone
    mov edx, [phonelen]
    call print_proc
    print_text line, 1

    print_text laddr, laddrlen
    mov ecx, addr
    mov edx, [addrlen]
    call print_proc
    print_text line, 1

    print_text lclass, lclasslen
    mov ecx, class
    mov edx, [classlen]
    call print_proc
    print_text line, linelen

    print_text sched_title, sched_titlelen
    print_text schedule, schedulelen

    print_text unit_prompt, unit_promptlen
    mov ecx, numbuf
    mov edx, 31
    call readln
    mov [numlen], eax
    mov ecx, numbuf
    mov edx, [numlen]
    call parse_int
    jc bad_units
    cmp eax, 0
    jl bad_units
    mov [units], eax

    mov eax, [units]
    imul eax, eax, 2108
    mov [fee], eax

    print_text line, linelen
    print_text unit_msg, unit_msglen
    mov eax, [units]
    call print_num
    print_text tuition_msg, tuition_msglen
    mov eax, [fee]
    call print_num

    mov eax, 1
    xor ebx, ebx
    int 0x80

bad_units:
    print_text invalid_msg, invalid_len
    mov eax, 1
    mov ebx, 1
    int 0x80

print_proc:
    push ebx
    mov eax, 4
    mov ebx, 1
    int 0x80
    pop ebx
    ret

readln:
    mov edi, ecx
    mov esi, edx
    xor ebp, ebp

.read_char:
    mov eax, 3
    xor ebx, ebx
    mov ecx, chr
    mov edx, 1
    int 0x80
    cmp eax, 1
    jne .done
    cmp byte [chr], 10
    je .done
    cmp ebp, esi
    jae .read_char
    mov al, [chr]
    mov [edi+ebp], al
    inc ebp
    jmp .read_char

.done:
    mov byte [edi+ebp], 0
    mov eax, ebp
    ret

parse_int:
    mov esi, ecx
    mov ecx, edx
    xor eax, eax
    test ecx, ecx
    jz .bad

.digits:
    movzx edx, byte [esi]
    cmp edx, '0'
    jb .bad
    cmp edx, '9'
    ja .bad
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    inc esi
    dec ecx
    jnz .digits
    clc
    ret

.bad:
    stc
    ret

print_num:
    mov byte [negflag], 0
    mov edi, outbuf+15
    mov byte [edi], 10
    dec edi
    cmp eax, 0
    jge .digits_start
    neg eax
    mov byte [negflag], 1

.digits_start:
    mov ebx, 10

.digits:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .digits
    cmp byte [negflag], 1
    jne .write
    mov byte [edi], '-'
    dec edi

.write:
    lea ecx, [edi+1]
    mov edx, outbuf+16
    sub edx, ecx
    call print_proc
    ret
