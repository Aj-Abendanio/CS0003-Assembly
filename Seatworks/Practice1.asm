;  RUN COMMAND:
;  (IF via docker): docker compose run --rm nasm
;  (IF in a folder):
;  cd /work/module1_exercises
:  ls -la
;  nasm -f elf32 program.asm -o program.o
;  ld -m elf_i386 program.o -o program
;  ./program

section .bss
    studentname_buffer resb 32
    studentid_buffer resb 32
    studentcourse_buffer resb 32

section .data
    prompt_studentname db "Enter Student Name: "
    len_prompt_studentname equ $ - prompt_studentname

    prompt_studentid db "Enter Student ID: "
    len_prompt_studentid equ $ - prompt_studentid

    prompt_studentcourse db "Enter Course/Program: "
    len_prompt_studentcourse equ $ - prompt_studentcourse

    record db 10, "--- Student Record ---", 10
    len_record equ $ - record

    studentname_label db "Name: "
    len_studentname equ $ - studentname_label

    studentid_label db "ID: "
    len_studentid equ $ - studentid_label

    studentcourse_label db "Course: "
    len_studentcourse equ $ - studentcourse_label

section .text
    global _start
  
_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_studentname
    mov edx, len_prompt_studentname
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, studentname_buffer
    mov edx, 32
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_studentid
    mov edx, len_prompt_studentid
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, studentid_buffer
    mov edx, 32
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_studentcourse
    mov edx, len_prompt_studentcourse
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, studentcourse_buffer
    mov edx, 32
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, record
    mov edx, len_record
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, studentname_label
    mov edx, len_studentname
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, studentname_buffer
    mov edx, 32
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, studentid_label
    mov edx, len_studentid
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, studentid_buffer
    mov edx, 32
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, studentcourse_label
    mov edx, len_studentcourse
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, studentcourse_buffer
    mov edx, 32
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
