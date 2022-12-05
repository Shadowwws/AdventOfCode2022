%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "3.in"
inputend:

section .data
tab: TIMES 100 db 0

section .text
global _start
_start:

    mov rsi, input
    xor r9, r9 ; The total sum
    mov rdi, rsi ; rdi = len of each line
    mov rcx, 2 ; to divide in the middle
    mov r14, tab ; to save our input line

    push 0
 .l:
    mov r15b, byte [rsi] ; move current character into r15
    mov byte [r14], r15b ; move it into our array
    inc r14
    inc rsi
    cmp byte [rsi], 10 ; compare if we're at the end of the line
    jne .l
    mov rax, rsi ; compute len of string in rax
    sub rax, rdi ; rax = rsi-rdi , rsi being current place in input and rdi last place before reading
    div rcx ; find the middle in rax
    mov r13, rax ; stock the middle
    jmp .compute

 .outer:
    inc rsi ; next line
    cmp rsi, inputend ; check for end
    jae _itoa
    mov rdi, rsi ; put rdi at the beginning of the line
    jmp .l ; loop

 .compute:
    mov r14, tab ; line in r14
    xor r8, r8 ; counter
  .a:
    mov r15b, byte [r14+rax]
    cmp byte [r14+r8], r15b ; compare [input+r8] and [input+rax]
    je .found
    inc r8 ; next char
    cmp r8, r13 ; compare if we reached the middle
    jl .a ; loop again
    inc rax ; next char after the middle
    jmp .compute

 .found:
    cmp byte [r14+r8], "a" ; check if it's lowercase or uppercase
    jae .min
    movzx r13, byte [r14+r8]
    add r9, r13
    sub r9, 38 ; add ascii value minus 38 in case of uppercase
    jmp .outer

  .min:
    movzx r13, byte [r14+r8]
    add r9, r13
    sub r9, 96 ; add ascii value minus 96 in case of lowercase
    jmp .outer

; Following part from alajpie, just to print the result, pretty fast and independant from the challenge.
_itoa:
    mov rbp, rsp
    mov r10, 10
    sub rsp, 22
                       
    mov byte [rbp-1], 10  
    lea r12, [rbp-2]
    ; r12: string pointer
    mov rax, r9

 .loop:
    xor edx, edx
    div r10
    add rdx, 48
    mov [r12], dl
    dec r12
    cmp r12, rsp
    jne .loop

    mov r9, rsp
    mov r11, 22
 .trim:
    inc r9
    dec r11
    cmp byte [r9], 48
    je .trim

    mov rax, 1
    mov rdi, 1
    mov rsi, r9
    mov rdx, r11
    syscall

    mov rax, 60
    mov rdi, 0
    syscall