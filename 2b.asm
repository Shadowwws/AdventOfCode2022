%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "2.in"
inputend:

section .text
global _start
_start:

    mov rsi, input
    xor r11, r11 ; My final sum
    mov r13, 1 ; 3 registers because cmove doesn't allow immediate value
    mov r14, 2 ;
    mov r15, 3 ;

 .l:
    xor r12, r12
    movzx r8, byte [rsi] ; r8 = Elf's pick
    add rsi, 2
    movzx r9, byte [rsi] ; r9 = The way the tour ends
    cmp r8, "A"
    je .rock
    cmp r8, "B"
    je .paper
    jmp .scissors

 .rock: ; It plays rock
    cmp r9, "X" ; I lose
    cmove r12, r15 ; scissors => 3
    je .next
    cmp r9, "Y" ; I draw
    cmove r12, r13 ; => rock => 1
    je .equal
    mov r12, 2
    jmp .win

 .paper: ; It plays paper
    cmp r9, "X" ; I lose
    cmove r12, r13
    je .next
    cmp r9, "Y" ; I draw
    cmove r12, r14
    je .equal
    mov r12, 3
    jmp .win

 .scissors: ; It plays scissors
    cmp r9, "X" ; I lose
    cmove r12, r14
    je .next
    cmp r9, "Y" ; I draw
    cmove r12, r15
    je .equal
    mov r12, 1
    jmp .win

 .equal:
    add r11, 3
    jmp .next

 .win:
    add r11, 6

 .next:
    add r11, r12 ; Add the value of my pick
    add rsi, 3  ; Add 3 because I'm on windows so \r\n for a new line , on Linux you add 2
    cmp rsi, inputend
    jl .l

 ; Following part from alajpie, just to print the result, pretty fast and independant from the challenge.
_itoa:
    mov rbp, rsp
    mov r10, 10
    sub rsp, 22
                       
    mov byte [rbp-1], 10  
    lea r12, [rbp-2]
    ; r12: string pointer
    mov rax, r11

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