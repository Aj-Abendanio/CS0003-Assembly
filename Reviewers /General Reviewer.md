# Assembly Reviewer - 32-bit x86 NASM on Linux

> **Scope:** 32-bit x86 Assembly using **NASM syntax** on Linux,
> especially the classic Linux `int 0x80` system-call interface. This
> matches programs that use `EAX`, `EBX`, `ECX`, `EDX`, `section .data`,
> `section .bss`, `section .text`, and `_start`.

------------------------------------------------------------------------

## 1. The Mental Model

Assembly is much closer to the CPU than Java/C++.

A typical program does this:

1.  Put data somewhere in memory.
2.  Put values or addresses into CPU registers.
3.  Tell the CPU which instruction to execute.
4.  For Linux services such as printing/input, put a **system-call
    number** and its arguments in registers.
5.  Execute `int 0x80`.

Example:

``` asm
section .data
    message db "Hello, World!", 10
    message_len equ $ - message

section .text
    global _start

_start:
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, message    ; address of text
    mov edx, message_len
    int 0x80

    mov eax, 1          ; sys_exit
    mov ebx, 0          ; exit status 0
    int 0x80
```

------------------------------------------------------------------------

# 2. Basic NASM Program Structure

``` asm
section .data
    ; initialized data

section .bss
    ; uninitialized/reserved memory

section .text
    global _start

_start:
    ; executable instructions
```

### `.data`

Stores initialized values.

``` asm
section .data
    message db "Hello", 10
    number  db 5
```

### `.bss`

Reserves memory without giving it an initial value.

``` asm
section .bss
    buffer resb 32
    value  resd 1
```

### `.text`

Contains executable machine instructions.

``` asm
section .text
    global _start

_start:
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### `global _start`

Makes `_start` visible to the linker as the program entry point.

### Comments

NASM comments begin with `;`.

``` asm
mov eax, 4      ; put 4 in EAX
```

------------------------------------------------------------------------

# 3. Registers You Need to Know

A **register** is a tiny, very fast storage location inside the CPU.

## 32-bit general-purpose registers

  Register   Common role
  ---------- -----------------------------------------------------------
  `EAX`      accumulator, arithmetic, system-call number, return value
  `EBX`      base/general data, syscall argument 1
  `ECX`      counter, syscall argument 2
  `EDX`      data/remainder, syscall argument 3
  `ESI`      source index
  `EDI`      destination index
  `EBP`      base/frame pointer
  `ESP`      stack pointer

Special registers:

  Register   Purpose
  ---------- --------------------------------------------------
  `EIP`      instruction pointer; address of next instruction
  `EFLAGS`   condition/status flags

You normally don't directly `mov` a value into `EIP`; jumps, calls, and
returns change it.

## Register sizes

`EAX` is 32 bits:

``` text
EAX = 32 bits
AX  = lower 16 bits of EAX
AH  = high 8 bits of AX
AL  = low 8 bits of AX
```

Similarly:

``` text
EBX -> BX -> BH / BL
ECX -> CX -> CH / CL
EDX -> DX -> DH / DL
```

Example:

``` asm
mov eax, 123
mov al, 5
```

The second instruction changes only the lowest 8 bits of `EAX`.

------------------------------------------------------------------------

# 4. Bits, Bytes, Words and Doublewords

  Name         Size
  ------- ---------
  bit         1 bit
  byte       8 bits
  word      16 bits
  dword     32 bits
  qword     64 bits

For this reviewer, `dword` naturally matches a 32-bit register.

------------------------------------------------------------------------

# 5. Declaring Data

## Initialized data

``` asm
db      ; define byte
dw      ; define word
dd      ; define doubleword
dq      ; define quadword
```

Examples:

``` asm
section .data
    letter db 'A'
    age db 20
    score dw 1000
    number dd 123456
```

Strings:

``` asm
name db "Angelika", 10
```

Multiple bytes:

``` asm
values db 10, 20, 30, 40
```

## Constants with `equ`

``` asm
MAX equ 100
```

A very important string-length pattern:

``` asm
message db "Hello!", 10
message_len equ $ - message
```

`$` means the current assembly position.

Therefore:

``` text
current position - beginning of message = number of bytes
```

This is safer than manually counting string characters.

------------------------------------------------------------------------

# 6. Reserving Memory

Use these in `.bss`:

``` asm
resb    ; reserve byte(s)
resw    ; reserve word(s)
resd    ; reserve doubleword(s)
resq    ; reserve quadword(s)
```

Examples:

``` asm
section .bss
    character resb 1
    name_buffer resb 32
    number resd 1
```

------------------------------------------------------------------------

# 7. MOV --- The Most Important Data-Movement Instruction

General syntax:

``` asm
mov destination, source
```

Examples:

``` asm
mov eax, 5
mov ebx, eax
mov ecx, message
```

Think:

``` text
destination <- source
```

NOT:

``` text
source <- destination
```

## Important restriction

Normal `mov` cannot generally copy memory directly to memory.

Wrong:

``` asm
mov [destination], [source]
```

Use a register in between:

``` asm
mov eax, [source]
mov [destination], eax
```

------------------------------------------------------------------------

# 8. Values vs Addresses --- EXTREMELY IMPORTANT

Consider:

``` asm
number dd 25
```

### Address

``` asm
mov eax, number
```

`EAX` receives the **address** of `number`.

### Value stored at the address

``` asm
mov eax, [number]
```

`EAX` receives `25`.

The brackets `[]` mean:

> Access the memory at this address.

This distinction is one of the most important concepts in Assembly.

------------------------------------------------------------------------

# 9. Memory Operand Sizes

Sometimes NASM needs to know how much memory is being accessed.

``` asm
mov byte [value], 5
mov word [value], 5
mov dword [value], 5
```

Size keywords:

``` asm
byte
word
dword
qword
```

Example:

``` asm
section .bss
    value resd 1

section .text
    mov dword [value], 100
```

------------------------------------------------------------------------

# 10. Linux 32-bit System Calls --- `int 0x80`

A **system call** asks the Linux kernel to perform an operating-system
service.

General pattern:

``` asm
mov eax, syscall_number
mov ebx, argument1
mov ecx, argument2
mov edx, argument3
int 0x80
```

For the classic 32-bit Linux ABI:

  Register   Purpose
  ---------- ----------------
  `EAX`      syscall number
  `EBX`      argument 1
  `ECX`      argument 2
  `EDX`      argument 3
  `ESI`      argument 4
  `EDI`      argument 5
  `EBP`      argument 6

After many syscalls, `EAX` contains the return value. Negative values
conventionally indicate an error.

For your introductory programs, the two most important calls are:

``` text
sys_exit  = 1
sys_read  = 3
sys_write = 4
```

These numbers apply to the **32-bit x86 Linux `int 0x80` ABI**. Do not
assume the same numbers apply to x86-64 `syscall`.

------------------------------------------------------------------------

# 11. Printing / Output --- `sys_write`

Pattern:

``` asm
mov eax, 4
mov ebx, 1
mov ecx, message
mov edx, message_len
int 0x80
```

Meaning:

``` text
EAX = 4              sys_write
EBX = 1              stdout
ECX = address        data to print
EDX = length         number of bytes
```

File descriptors commonly used:

``` text
0 = stdin
1 = stdout
2 = stderr
```

Complete example:

``` asm
section .data
    message db "Assembly!", 10
    message_len equ $ - message

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_len
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
```

`10` is the ASCII line-feed/newline byte on Linux.

------------------------------------------------------------------------

# 12. User Input --- `sys_read`

Pattern:

``` asm
mov eax, 3
mov ebx, 0
mov ecx, buffer
mov edx, buffer_size
int 0x80
```

Meaning:

``` text
EAX = 3          sys_read
EBX = 0          stdin
ECX = buffer     where input will be stored
EDX = size       maximum bytes to read
```

Example:

``` asm
section .bss
    buffer resb 32

section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 32
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
```

Important: after a successful `sys_read`, `EAX` contains the **number of
bytes actually read**.

That is useful when echoing input.

------------------------------------------------------------------------

# 13. Input + Output / Echo Program

``` asm
section .data
    prompt db "Enter your name: "
    prompt_len equ $ - prompt

section .bss
    name resb 32

section .text
    global _start

_start:
    ; print prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; read input
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 32
    int 0x80

    ; EAX now contains number of bytes read
    mov edx, eax

    ; print entered input
    mov eax, 4
    mov ebx, 1
    mov ecx, name
    int 0x80

    ; exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

------------------------------------------------------------------------

# 14. Exit

Always understand this ending:

``` asm
mov eax, 1
mov ebx, 0
int 0x80
```

Meaning:

``` text
EAX = sys_exit
EBX = exit status
```

`0` conventionally means successful termination.

------------------------------------------------------------------------

# 15. Addressing Modes

Addressing modes describe **where an operand comes from**.

## Immediate addressing

The value is directly written in the instruction.

``` asm
mov eax, 10
```

`10` is an immediate value.

## Register addressing

The operand is stored in a register.

``` asm
mov eax, ebx
```

## Direct memory addressing

Access a known memory location:

``` asm
mov eax, [number]
```

## Register-indirect addressing

A register contains the memory address:

``` asm
mov esi, number
mov eax, [esi]
```

## Base + displacement

``` asm
mov eax, [ebx + 4]
```

Access memory four bytes after the address in `EBX`.

## Indexed addressing

``` asm
mov eax, [array + esi]
```

## Base + index

``` asm
mov eax, [ebx + esi]
```

## Scaled-index addressing

x86 memory operands can use:

``` asm
[base + index*scale + displacement]
```

where scale is normally:

``` text
1, 2, 4, or 8
```

Example for a dword array:

``` asm
mov eax, [numbers + esi*4]
```

If `ESI = 2`, this accesses the third 4-byte integer.

------------------------------------------------------------------------

# 16. LEA --- Load Effective Address

Syntax:

``` asm
lea destination, [address_expression]
```

Example:

``` asm
lea eax, [ebx + ecx*4]
```

`LEA` calculates an address/expression. It does **not** dereference that
address like `mov eax, [ ... ]` does.

It can also be useful for arithmetic:

``` asm
lea eax, [eax + eax*2]
```

This computes roughly:

``` text
EAX = EAX * 3
```

without reading memory.

------------------------------------------------------------------------

# 17. Arithmetic Instructions

## Addition --- `ADD`

``` asm
add destination, source
```

Example:

``` asm
mov eax, 5
add eax, 3
```

Result:

``` text
EAX = 8
```

## Subtraction --- `SUB`

``` asm
sub destination, source
```

Example:

``` asm
mov eax, 10
sub eax, 4
```

Result:

``` text
EAX = 6
```

## Increment --- `INC`

``` asm
inc eax
```

Adds 1.

## Decrement --- `DEC`

``` asm
dec eax
```

Subtracts 1.

## Negation --- `NEG`

``` asm
neg eax
```

Changes the arithmetic sign using two's-complement negation.

------------------------------------------------------------------------

# 18. Multiplication

There are two important families.

## Unsigned multiplication --- `MUL`

``` asm
mul operand
```

For a 32-bit operand:

``` asm
mov eax, 5
mov ebx, 3
mul ebx
```

Conceptually:

``` text
EDX:EAX = EAX * EBX
```

The 64-bit product is split between:

``` text
EDX = high 32 bits
EAX = low 32 bits
```

## Signed multiplication --- `IMUL`

Simple form:

``` asm
imul ebx
```

Useful additional forms include:

``` asm
imul eax, ebx
imul eax, ebx, 5
```

Example:

``` asm
mov eax, 5
imul eax, 4
```

Result:

``` text
EAX = 20
```

------------------------------------------------------------------------

# 19. Division

## Unsigned division --- `DIV`

For a 32-bit divisor:

``` asm
div operand
```

It divides:

``` text
EDX:EAX / operand
```

and returns:

``` text
EAX = quotient
EDX = remainder
```

Simple unsigned example:

``` asm
mov eax, 10
xor edx, edx
mov ebx, 3
div ebx
```

Result:

``` text
EAX = 3
EDX = 1
```

### Why `xor edx, edx`?

Because `div ebx` uses the combined `EDX:EAX` dividend. For a small
unsigned value already in `EAX`, you usually need the high half (`EDX`)
to be zero.

## Signed division --- `IDIV`

For signed 32-bit division, prepare `EDX:EAX` using:

``` asm
cdq
```

Example:

``` asm
mov eax, -10
cdq
mov ebx, 3
idiv ebx
```

`CDQ` sign-extends `EAX` into `EDX:EAX`.

------------------------------------------------------------------------

# 20. Arithmetic Quick Reference

``` asm
add eax, ebx       ; EAX = EAX + EBX
sub eax, ebx       ; EAX = EAX - EBX
inc eax            ; EAX++
dec eax            ; EAX--
neg eax            ; EAX = -EAX

mul ebx            ; unsigned EDX:EAX = EAX * EBX
imul ebx           ; signed multiplication
div ebx            ; unsigned EDX:EAX / EBX
idiv ebx           ; signed division
```

------------------------------------------------------------------------

# 21. Logical / Bitwise Instructions

These operate on individual bits.

## AND

``` asm
and eax, ebx
```

Truth rule:

``` text
1 AND 1 = 1
everything else = 0
```

Useful for clearing/masking bits.

## OR

``` asm
or eax, ebx
```

``` text
0 OR 0 = 0
otherwise = 1
```

Useful for setting bits.

## XOR

``` asm
xor eax, ebx
```

Different bits produce `1`.

A famous pattern:

``` asm
xor eax, eax
```

sets `EAX` to zero.

## NOT

``` asm
not eax
```

Flips every bit.

## TEST

``` asm
test eax, eax
```

Performs an AND for flag-setting purposes but does not store the result.

Often used to check whether a register is zero:

``` asm
test eax, eax
jz is_zero
```

------------------------------------------------------------------------

# 22. Shift Instructions

## Shift left

``` asm
shl eax, 1
```

Shifting left by one bit often corresponds to multiplying an
unsigned/non-overflowing value by 2.

## Logical shift right

``` asm
shr eax, 1
```

Shifts in zero bits. Useful for unsigned values.

## Arithmetic shift right

``` asm
sar eax, 1
```

Preserves the sign bit, making it useful for signed values.

You may also encounter:

``` asm
sal eax, 1
```

For x86, `SAL` is effectively the same operation as `SHL`.

------------------------------------------------------------------------

# 23. Comparison --- `CMP`

Syntax:

``` asm
cmp operand1, operand2
```

Conceptually, it performs:

``` text
operand1 - operand2
```

but does not save the subtraction result. It updates CPU flags.

Example:

``` asm
cmp eax, ebx
je equal
```

------------------------------------------------------------------------

# 24. CPU Flags You Should Recognize

Important `EFLAGS` bits include:

  Flag   Meaning
  ------ ---------------
  `ZF`   Zero Flag
  `CF`   Carry Flag
  `SF`   Sign Flag
  `OF`   Overflow Flag

`CMP`, arithmetic, and logical operations affect flags.

Conditional jumps inspect these flags.

------------------------------------------------------------------------

# 25. Conditional Jumps

## Equality

``` asm
je label
jz label
```

Jump when equal / zero.

``` asm
jne label
jnz label
```

Jump when not equal / not zero.

## Signed comparisons

After:

``` asm
cmp eax, ebx
```

use:

``` asm
jg label       ; greater
jge label      ; greater or equal
jl label       ; less
jle label      ; less or equal
```

## Unsigned comparisons

``` asm
ja label       ; above
jae label      ; above or equal
jb label       ; below
jbe label      ; below or equal
```

This distinction matters.

**Signed:** `JG/JGE/JL/JLE`

**Unsigned:** `JA/JAE/JB/JBE`

------------------------------------------------------------------------

# 26. Unconditional Jump

``` asm
jmp label
```

Example:

``` asm
_start:
    jmp hello

hello:
    ; code
```

------------------------------------------------------------------------

# 27. IF / ELSE in Assembly

High-level idea:

``` text
if EAX == EBX
    equal
else
    not equal
```

Assembly:

``` asm
cmp eax, ebx
je equal_case

; else
mov ecx, not_equal_message
jmp done

equal_case:
mov ecx, equal_message

done:
```

There is no normal Java-style `if` keyword. You construct control flow
using comparisons and jumps.

------------------------------------------------------------------------

# 28. Loops

Basic loop with `DEC` and `JNZ`:

``` asm
mov ecx, 5

loop_start:
    ; repeated code

    dec ecx
    jnz loop_start
```

There is also an x86 `loop` instruction:

``` asm
mov ecx, 5

again:
    ; repeated code
    loop again
```

`loop` decrements `ECX` and jumps if it is not zero. In many real
programs, explicit `dec`/`jnz` is preferred, but you should recognize
both.

------------------------------------------------------------------------

# 29. Arrays

Byte array:

``` asm
section .data
    numbers db 10, 20, 30, 40
```

Access first element:

``` asm
mov al, [numbers]
```

Second byte:

``` asm
mov al, [numbers + 1]
```

Using an index:

``` asm
mov esi, 2
mov al, [numbers + esi]
```

## Dword array

``` asm
numbers dd 10, 20, 30, 40
```

Each element occupies 4 bytes.

``` asm
mov esi, 2
mov eax, [numbers + esi*4]
```

This loads the third element (`30`).

------------------------------------------------------------------------

# 30. Strings

A string is fundamentally a sequence of bytes.

``` asm
message db "Hello", 10
```

Memory conceptually contains:

``` text
'H' 'e' 'l' 'l' 'o' newline
```

NASM/Linux `sys_write` does not require a C-style null terminator
because you explicitly provide a byte count.

``` asm
message_len equ $ - message
```

------------------------------------------------------------------------

# 31. ASCII --- VERY IMPORTANT FOR INPUT

When a user types:

``` text
5
```

`sys_read` does **not** give you the integer `5`.

It gives you the character encoding for `'5'`.

ASCII:

``` text
'0' = 48
'1' = 49
...
'9' = 57
```

## ASCII digit -\> integer

``` asm
sub al, '0'
```

Example:

``` asm
mov al, '7'
sub al, '0'
```

Now `AL` contains numeric `7`.

## Integer digit -\> ASCII

``` asm
add al, '0'
```

Example:

``` asm
mov al, 7
add al, '0'
```

Now `AL` contains the ASCII character `'7'`.

This simple technique only directly handles a **single decimal digit**.

------------------------------------------------------------------------

# 32. Reading One Digit

``` asm
section .bss
    input resb 2

section .text

    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 2
    int 0x80

    mov al, [input]
    sub al, '0'
```

Why reserve/read 2 bytes in a simple terminal example?

Typing:

``` text
5 + Enter
```

commonly provides:

``` text
'5' + newline
```

------------------------------------------------------------------------

# 33. Multi-Digit Decimal Input

For text such as:

``` text
123
```

you cannot simply subtract `'0'` from the whole string.

The basic conversion algorithm is:

``` text
result = 0

for each digit:
    result = result * 10
    result = result + (character - '0')
```

Conceptually:

``` asm
; digit character in AL
sub al, '0'
; extend/convert it as needed
; result = result * 10 + digit
```

This is why integer input/output in raw Assembly is substantially more
work than Java's `Scanner`.

------------------------------------------------------------------------

# 34. Printing Numbers

`sys_write` prints **bytes/text**, not an integer magically.

Wrong mental model:

``` asm
mov eax, 123
; somehow print EAX
```

You must convert integer `123` to ASCII bytes:

``` text
'1' '2' '3'
```

A common integer-to-decimal algorithm repeatedly divides by 10:

``` text
123 / 10 -> quotient 12, remainder 3
12  / 10 -> quotient 1,  remainder 2
1   / 10 -> quotient 0,  remainder 1
```

Remainders appear backwards, so they are commonly stored on the stack or
written into a buffer from the end.

------------------------------------------------------------------------

# 35. Stack

The stack is a **LIFO** structure:

> Last In, First Out

Important register:

``` asm
ESP
```

points to the top of the stack.

## PUSH

``` asm
push eax
```

Places a value on the stack.

In 32-bit mode, a normal `push eax` pushes 4 bytes and decreases `ESP`.

## POP

``` asm
pop eax
```

Removes the top stack value into `EAX` and increases `ESP`.

Example:

``` asm
mov eax, 10
push eax

mov eax, 20

pop eax
```

After the `pop`, `EAX` becomes `10`.

------------------------------------------------------------------------

# 36. CALL and RET --- Procedures

A reusable block of Assembly code can be written as a
procedure/function.

``` asm
print_message:
    ; instructions
    ret
```

Call it:

``` asm
call print_message
```

`CALL` saves the return address on the stack and transfers control to
the procedure.

`RET` pops that return address and continues execution there.

Example:

``` asm
section .text
global _start

_start:
    call my_function

    mov eax, 1
    mov ebx, 0
    int 0x80

my_function:
    ; do something
    ret
```

------------------------------------------------------------------------

# 37. Basic Stack Frame Pattern

You may encounter:

``` asm
my_function:
    push ebp
    mov ebp, esp

    ; function body

    mov esp, ebp
    pop ebp
    ret
```

or the equivalent cleanup:

``` asm
leave
ret
```

A traditional stack frame lets code access arguments/local storage
relative to `EBP`.

------------------------------------------------------------------------

# 38. Common Calling-Convention Idea

For functions following a 32-bit C-style calling convention such as
cdecl, arguments are commonly placed on the stack and the return value
is commonly placed in `EAX`.

Example conceptual call:

``` asm
push 20
push 10
call add_numbers
add esp, 8
```

Inside a classic EBP-framed function:

``` text
[ebp + 8]  = first argument
[ebp + 12] = second argument
```

Exact conventions matter when interoperating with other code; do not
assume every function or OS interface follows the same convention.

------------------------------------------------------------------------

# 39. Useful Data-Movement Instructions

## `MOV`

``` asm
mov eax, ebx
```

## `XCHG`

Swap:

``` asm
xchg eax, ebx
```

## `MOVZX`

Move and zero-extend:

``` asm
movzx eax, byte [value]
```

Example: copy an 8-bit unsigned value into a 32-bit register while
making the upper bits zero.

## `MOVSX`

Move and sign-extend:

``` asm
movsx eax, byte [value]
```

Useful for signed smaller values.

------------------------------------------------------------------------

# 40. Byte vs Dword Loading

Suppose:

``` asm
value db 255
```

This is wrong if you intend to read only that one byte:

``` asm
mov eax, [value]
```

because a 32-bit `EAX` load reads four bytes.

Use:

``` asm
movzx eax, byte [value]
```

Now one byte is read and extended to 32 bits.

------------------------------------------------------------------------

# 41. Labels

Labels mark locations in your program.

``` asm
_start:
```

Another:

``` asm
repeat:
```

Use them as jump destinations:

``` asm
jmp repeat
```

or addresses:

``` asm
message db "Hi"
mov ecx, message
```

------------------------------------------------------------------------

# 42. Logical Example

``` asm
mov eax, 1100b
mov ebx, 1010b
and eax, ebx
```

Result:

``` text
1000b
```

NASM number notation examples:

``` asm
mov eax, 10       ; decimal
mov eax, 0Ah      ; hexadecimal
mov eax, 1010b    ; binary
```

Be careful with hexadecimal literals beginning with A-F in NASM; a
leading `0` can make the token unambiguously numeric, e.g. `0FFh`.

------------------------------------------------------------------------

# 43. Newline

Linux newline:

``` asm
newline db 10
```

or directly:

``` asm
message db "Hello", 10
```

Two lines:

``` asm
message db "Line 1", 10
        db "Line 2", 10
```

------------------------------------------------------------------------

# 44. Printing Multiple Messages

``` asm
section .data
    first db "Hello", 10
    first_len equ $ - first

    second db "World", 10
    second_len equ $ - second

section .text
global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, first
    mov edx, first_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, second
    mov edx, second_len
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
```

------------------------------------------------------------------------

# 45. Complete User-Profile Example

``` asm
section .data
    prompt_name db "Enter Student Name: "
    len_prompt_name equ $ - prompt_name

    prompt_id db "Enter Student ID: "
    len_prompt_id equ $ - prompt_id

    record db 10, "--- Student Record ---", 10
    len_record equ $ - record

    name_label db "Name: "
    len_name_label equ $ - name_label

    id_label db "ID: "
    len_id_label equ $ - id_label

section .bss
    name_buffer resb 32
    id_buffer resb 32

    name_len resd 1
    id_len resd 1

section .text
    global _start

_start:
    ; prompt for name
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_name
    mov edx, len_prompt_name
    int 0x80

    ; read name
    mov eax, 3
    mov ebx, 0
    mov ecx, name_buffer
    mov edx, 32
    int 0x80
    mov [name_len], eax

    ; prompt for ID
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_id
    mov edx, len_prompt_id
    int 0x80

    ; read ID
    mov eax, 3
    mov ebx, 0
    mov ecx, id_buffer
    mov edx, 32
    int 0x80
    mov [id_len], eax

    ; heading
    mov eax, 4
    mov ebx, 1
    mov ecx, record
    mov edx, len_record
    int 0x80

    ; Name:
    mov eax, 4
    mov ebx, 1
    mov ecx, name_label
    mov edx, len_name_label
    int 0x80

    ; actual name
    mov eax, 4
    mov ebx, 1
    mov ecx, name_buffer
    mov edx, [name_len]
    int 0x80

    ; ID:
    mov eax, 4
    mov ebx, 1
    mov ecx, id_label
    mov edx, len_id_label
    int 0x80

    ; actual ID
    mov eax, 4
    mov ebx, 1
    mov ecx, id_buffer
    mov edx, [id_len]
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
```

Notice why the read lengths are saved: every later syscall overwrites
`EAX`.

------------------------------------------------------------------------

# 46. Common Mistakes

## Mistake 1 --- Forgetting `_start`

``` asm
global _start

_start:
```

## Mistake 2 --- Wrong syscall register

Wrong:

``` asm
mov ebx, 4
```

Correct syscall number location:

``` asm
mov eax, 4
```

## Mistake 3 --- Wrong `sys_write` arguments

Remember:

``` asm
mov eax, 4
mov ebx, 1
mov ecx, message
mov edx, message_len
int 0x80
```

Mnemonic:

``` text
EAX = action
EBX = where
ECX = what
EDX = how much
```

For `sys_read`:

``` text
EAX = read
EBX = where from
ECX = where to store
EDX = maximum amount
```

## Mistake 4 --- Forgetting `int 0x80`

Loading registers alone does not execute the system call.

## Mistake 5 --- Wrong string length

Avoid manually counting:

``` asm
message_len equ $ - message
```

## Mistake 6 --- Confusing value and address

``` asm
mov eax, number       ; address
mov eax, [number]     ; value in memory
```

## Mistake 7 --- Treating keyboard input as a number

Keyboard input is text/bytes.

``` asm
sub al, '0'
```

converts one decimal digit to its numeric value.

## Mistake 8 --- Trying memory-to-memory `mov`

Use a register in between.

## Mistake 9 --- Not preparing `EDX` before division

Unsigned:

``` asm
xor edx, edx
div ebx
```

Signed:

``` asm
cdq
idiv ebx
```

## Mistake 10 --- Mixing 32-bit and 64-bit tutorials

Your course-style code:

``` asm
eax
ebx
int 0x80
```

is **32-bit x86 Linux**.

A 64-bit tutorial may instead use:

``` asm
rax
rdi
rsi
rdx
syscall
```

Do not blindly mix the two ABIs.

------------------------------------------------------------------------

# 47. Essential Instruction Cheat Sheet

## Data

``` asm
mov dest, src
lea dest, [address]
xchg eax, ebx
movzx eax, byte [x]
movsx eax, byte [x]
```

## Arithmetic

``` asm
add eax, ebx
sub eax, ebx
inc eax
dec eax
neg eax
mul ebx
imul ebx
div ebx
idiv ebx
```

## Logical

``` asm
and eax, ebx
or eax, ebx
xor eax, ebx
not eax
test eax, eax
```

## Shifts

``` asm
shl eax, 1
shr eax, 1
sar eax, 1
```

## Comparison

``` asm
cmp eax, ebx
```

## Jumps

``` asm
jmp label

je label
jne label

jg label
jge label
jl label
jle label

ja label
jae label
jb label
jbe label

jz label
jnz label
```

## Stack/procedure

``` asm
push eax
pop eax
call function
ret
```

------------------------------------------------------------------------

# 48. The Four Syscall Lines You Should Memorize

### PRINT

``` asm
mov eax, 4
mov ebx, 1
mov ecx, message
mov edx, message_len
int 0x80
```

### INPUT

``` asm
mov eax, 3
mov ebx, 0
mov ecx, buffer
mov edx, buffer_size
int 0x80
```

### EXIT

``` asm
mov eax, 1
mov ebx, 0
int 0x80
```

### STRING LENGTH

``` asm
message_len equ $ - message
```

------------------------------------------------------------------------

# 49. How Assembly Becomes an Executable

For NASM source:

``` text
program.asm
     |
     | NASM assembler
     v
program.o
     |
     | linker (ld)
     v
program
     |
     | Linux executes it
     v
output
```

Important distinction:

> NASM **assembles** source code. `ld` **links** object code. The shell
> then **runs** the executable.

------------------------------------------------------------------------

# 50. Assemble and Run on Ubuntu/Linux

Install the required tools:

``` bash
sudo apt update
sudo apt install nasm binutils
```

Check NASM:

``` bash
nasm -v
```

Suppose your source is:

``` text
hello.asm
```

### Step 1 --- Assemble

``` bash
nasm -f elf32 hello.asm -o hello.o
```

Meaning:

``` text
nasm        = assembler
-f elf32    = create 32-bit ELF object code
hello.asm   = source
-o hello.o  = output object file
```

### Step 2 --- Link

``` bash
ld -m elf_i386 hello.o -o hello
```

Meaning:

``` text
ld            = linker
-m elf_i386   = link as 32-bit x86 ELF
hello.o       = object file
-o hello      = executable filename
```

### Step 3 --- Run

``` bash
./hello
```

Complete workflow:

``` bash
nasm -f elf32 hello.asm -o hello.o
ld -m elf_i386 hello.o -o hello
./hello
```

------------------------------------------------------------------------

# 51. Useful Linux Commands While Working

Current folder:

``` bash
pwd
```

List files:

``` bash
ls
```

Detailed list:

``` bash
ls -l
```

Change directory:

``` bash
cd foldername
```

Check executable type:

``` bash
file hello
```

You should see that it is a 32-bit ELF executable.

Remove build files:

``` bash
rm hello.o hello
```

Rebuild:

``` bash
nasm -f elf32 hello.asm -o hello.o
ld -m elf_i386 hello.o -o hello
./hello
```

------------------------------------------------------------------------

# 52. VS Code + Ubuntu Workflow

VS Code is your **editor**. NASM and `ld` actually build the program.

Recommended structure:

``` text
Assembly/
    hello.asm
```

Open the integrated terminal:

``` text
Terminal -> New Terminal
```

Then:

``` bash
nasm -f elf32 hello.asm -o hello.o
ld -m elf_i386 hello.o -o hello
./hello
```

An Assembly-language extension can provide syntax highlighting, but the
extension itself does not replace NASM.

If VS Code is running on Windows while your assembler is inside
Ubuntu/WSL or Docker, make sure the terminal in which you issue these
commands is actually the Linux environment containing NASM.

------------------------------------------------------------------------

# 53. Docker Workflow

Docker is useful when your host OS does not directly provide the Linux
environment expected by your course.

A simple approach is to create an Ubuntu container and install the tools
there.

Start an interactive Ubuntu container:

``` bash
docker run --rm -it ubuntu:latest bash
```

Inside:

``` bash
apt update
apt install -y nasm binutils
```

Then you need your source code inside the container.

A more useful approach is to mount your current project folder.

On Linux/macOS or a compatible shell:

``` bash
docker run --rm -it -v "$PWD:/work" -w /work ubuntu:latest bash
```

Inside the container:

``` bash
apt update
apt install -y nasm binutils
nasm -f elf32 hello.asm -o hello.o
ld -m elf_i386 hello.o -o hello
./hello
```

The exact host-folder syntax can differ depending on your operating
system/shell.

For repeated coursework, installing NASM every time is inefficient. You
can instead keep a container/image configured with the tools or use a
Dockerfile/dev-container setup.

------------------------------------------------------------------------

# 54. VS Code + Docker Mental Model

``` text
VS Code
   |
   | edit
   v
hello.asm
   |
   | mounted/shared
   v
Docker Ubuntu
   |
   | nasm
   v
hello.o
   |
   | ld
   v
hello
   |
   | run
   v
output
```

VS Code does not itself execute Assembly. The Linux environment inside
Docker supplies NASM, the linker, and the execution environment.

------------------------------------------------------------------------

# 55. NetBeans Workflow

NetBeans is primarily an IDE for languages such as Java/C/C++; it is
**not itself a NASM assembler**. If your school setup uses NetBeans for
Assembly, the actual build still needs an external assembler/toolchain
or a course-specific configuration/plugin.

The underlying NASM commands remain:

``` bash
nasm -f elf32 program.asm -o program.o
ld -m elf_i386 program.o -o program
./program
```

Therefore remember the separation:

``` text
NetBeans / VS Code = editor / IDE
NASM               = assembler
ld                 = linker
Linux               = execution environment
```

If your professor has supplied a specific NetBeans project template,
plugin, Docker configuration, or build command, use that configuration
rather than assuming generic NetBeans can compile `.asm` files by
itself.

------------------------------------------------------------------------

# 56. Compile/Build Process You Can Explain to Your Professor

If asked to explain what happens:

> First, I write the Assembly source code in a `.asm` file. I use NASM
> with `-f elf32` to assemble it into a 32-bit ELF object file. Then I
> use the GNU linker with `-m elf_i386` to link the object file into a
> 32-bit executable. Finally, I execute the program in Linux using
> `./filename`.

Commands:

``` bash
nasm -f elf32 program.asm -o program.o
ld -m elf_i386 program.o -o program
./program
```

------------------------------------------------------------------------

# 57. Debugging / Inspection Commands Worth Knowing

Show file type:

``` bash
file program
```

Disassemble an executable:

``` bash
objdump -d program
```

Disassemble using Intel-style syntax:

``` bash
objdump -d -Mintel program
```

Inspect ELF information:

``` bash
readelf -h program
```

If GDB is installed:

``` bash
gdb ./program
```

Inside GDB, useful commands include:

``` text
break _start
run
info registers
stepi
nexti
disassemble
quit
```

`stepi` executes one machine instruction at a time.

------------------------------------------------------------------------

# 58. NASM Errors vs Linker Errors vs Runtime Errors

Learn which stage failed.

## Assembler error

Example:

``` text
parser: instruction expected
```

Usually means your `.asm` syntax is wrong.

Stage:

``` text
.asm -> NASM -> ERROR
```

## Linker error

The Assembly may have produced `.o`, but `ld` cannot create the final
executable.

Stage:

``` text
.asm -> .o -> ld -> ERROR
```

## Runtime problem

The executable exists, but crashes, hangs, or produces incorrect output.

``` text
.asm -> .o -> executable -> WRONG BEHAVIOR
```

This often involves registers, addresses, lengths, stack use, bad memory
access, or incorrect program logic.

------------------------------------------------------------------------

# 59. A Template Worth Memorizing

``` asm
section .data
    message db "Hello", 10
    message_len equ $ - message

section .bss
    buffer resb 32

section .text
    global _start

_start:

    ; PRINT
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, message_len
    int 0x80

    ; INPUT
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 32
    int 0x80

    ; EXIT
    mov eax, 1
    mov ebx, 0
    int 0x80
```

------------------------------------------------------------------------

# 60. What You Should Memorize vs Understand

## Memorize

``` asm
section .data
section .bss
section .text
global _start
_start:
```

Print:

``` asm
eax = 4
ebx = 1
ecx = address
edx = length
int 0x80
```

Input:

``` asm
eax = 3
ebx = 0
ecx = buffer
edx = size
int 0x80
```

Exit:

``` asm
eax = 1
ebx = 0
int 0x80
```

Build:

``` bash
nasm -f elf32 file.asm -o file.o
ld -m elf_i386 file.o -o file
./file
```

Core instructions:

``` asm
mov
add
sub
inc
dec
mul
imul
div
idiv
and
or
xor
not
test
cmp
jmp
je
jne
jg
jl
jge
jle
push
pop
call
ret
```

## Understand

Do not merely memorize these:

-   what a register is
-   address vs value
-   what `[]` means
-   why strings are bytes
-   ASCII vs numeric values
-   what system calls do
-   how `CMP` + jumps form decisions
-   signed vs unsigned comparisons
-   why `EDX:EAX` matters for division/multiplication
-   how arrays use addresses and offsets
-   how the stack works
-   what `CALL` and `RET` actually do
-   assembler vs linker vs executable

------------------------------------------------------------------------

# 61. Ultra-Short Exam Cheat Sheet

``` asm
; ===== STRUCTURE =====

section .data
    msg db "Hello", 10
    len equ $ - msg

section .bss
    buf resb 32

section .text
global _start

_start:


; ===== PRINT =====

mov eax, 4
mov ebx, 1
mov ecx, msg
mov edx, len
int 0x80


; ===== INPUT =====

mov eax, 3
mov ebx, 0
mov ecx, buf
mov edx, 32
int 0x80


; ===== EXIT =====

mov eax, 1
mov ebx, 0
int 0x80


; ===== DATA =====

db      ; byte
dw      ; word
dd      ; dword

resb    ; reserve byte
resw    ; reserve word
resd    ; reserve dword


; ===== MOVEMENT =====

mov eax, 5
mov eax, ebx
mov eax, [number]
lea eax, [address]


; ===== ARITHMETIC =====

add eax, ebx
sub eax, ebx
inc eax
dec eax
neg eax

mul ebx
imul ebx

xor edx, edx
div ebx

cdq
idiv ebx


; ===== LOGIC =====

and eax, ebx
or eax, ebx
xor eax, ebx
not eax
test eax, eax

shl eax, 1
shr eax, 1
sar eax, 1


; ===== COMPARE =====

cmp eax, ebx

je equal
jne not_equal

; signed
jg greater
jge greater_equal
jl less
jle less_equal

; unsigned
ja above
jae above_equal
jb below
jbe below_equal


; ===== STACK =====

push eax
pop eax
call function
ret


; ===== ASCII DIGIT =====

sub al, '0'       ; ASCII -> number
add al, '0'       ; number -> ASCII


; ===== ARRAY =====

mov al, [array + esi]
mov eax, [dword_array + esi*4]


; ===== BUILD =====

; nasm -f elf32 file.asm -o file.o
; ld -m elf_i386 file.o -o file
; ./file
```

------------------------------------------------------------------------

# 62. Final Mental Map

When reading Assembly, ask these questions in order:

``` text
1. What is in memory?
        |
        v
   .data / .bss

2. What values are currently in the registers?
        |
        v
   EAX EBX ECX EDX ESI EDI ...

3. Is an operand a VALUE or an ADDRESS?
        |
        v
   number vs [number]

4. What does this instruction change?
        |
        v
   MOV / ADD / SUB / CMP / ...

5. Did the instruction change EFLAGS?
        |
        v
   conditional jump?

6. Is this a system call?
        |
        v
   EAX = syscall number
   arguments = registers
   int 0x80

7. Is the data numeric or ASCII text?
        |
        v
   convert when necessary

8. Where will execution go next?
        |
        v
   next instruction / JMP / CALL / RET
```

If you understand those questions, Assembly stops looking like a
collection of random `mov` instructions and starts looking like explicit
movement of **data, addresses, and control flow**.

------------------------------------------------------------------------

## One Last Warning: 32-bit vs 64-bit

This reviewer is specifically for:

``` text
x86
32-bit
NASM syntax
Linux
int 0x80
```

Typical 32-bit course code:

``` asm
mov eax, 4
mov ebx, 1
mov ecx, message
mov edx, message_len
int 0x80
```

Do **not** mix it with an x86-64 tutorial that uses a different syscall
ABI, for example:

``` asm
rax
rdi
rsi
rdx
syscall
```

The concepts are related, but the syscall numbers, calling interface,
register sizes, and build target differ.

------------------------------------------------------------------------

# Quick Build Reminder

Every time you forget:

``` bash
nasm -f elf32 program.asm -o program.o
ld -m elf_i386 program.o -o program
./program
```

**Source -\> Assemble -\> Object -\> Link -\> Executable -\> Run**
