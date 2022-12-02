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
    xor r11, r11 ; The final sum

 .l:
    movzx r8, byte [rsi] ; r8 = Elf's pick
    add rsi, 2
    movzx r9, byte [rsi] ; r9 = My pick
    add r11, r9 ; add the value of our choice (1,2,3)
    sub r11, 'W' ; second-half of the add
    cmp r8, "A"
    je .rock
    cmp r8, "B"
    je .paper
    jmp .scissors

 .rock: ; The elf is playing rock
    cmp r9, "X"
    je .equal
    cmp r9, "Y"
    je .win
    jmp .next

 .paper: ; The elf is playing paper
    cmp r9, "Y"
    je .equal
    cmp r9, "Z"
    je .win
    jmp .next

 .scissors: ; The elf is playing scissors
    cmp r9, "Z"
    je .equal
    cmp r9, "X"
    je .win
    jmp .next

 .equal:
    add r11, 3
    jmp .next

 .win:
    add r11, 6

 .next:
    add rsi, 3 ; Add 3 because I'm on windows so \r\n for a new line , on Linux you add 2
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