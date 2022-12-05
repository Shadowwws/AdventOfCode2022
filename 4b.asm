%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "4.in"
inputend:

section .text
global _start
_start:

    mov rsi, input
    xor r9, r9 ; The sum

_atoi:                    ; Convert input to int

 .setup:
    xor eax, eax

 .inner:
    imul rax, 10
    movzx rbx, byte [rsi]
    add rax, rbx
    sub rax, 48
    inc rsi
    cmp byte [rsi], "-"
    ja .inner
    push rax ; add the new read number to the stack 
    cmp byte [rsi], 10
    je _solv
    inc rsi
    jmp .setup

_solv:
   mov r10, [rsp]
   sub r10, [rsp+16]

   cmp r10, 0
   jg .positive
   jl .negative
   jmp .bingo

 .negative:
   mov r11, [rsp]
   sub r11, [rsp+24]
   cmp r11, 0
   jge .bingo
   jmp .set

 .positive:
   mov r11, [rsp+8]
   sub r11, [rsp+16]
   cmp r11, 0
   jle .bingo
   jmp .set 

 .bingo:
   inc r9

 .set:
   add rsp, 32
   inc rsi
   cmp rsi, inputend
   jae _itoa
   jmp _atoi

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