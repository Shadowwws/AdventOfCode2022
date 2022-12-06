%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "6.in"
inputend:

section .data
align 16
tab: TIMES 16 db 0

section .text
global _start
_start:
    xor rcx, rcx
    mov rsi, input ; input in rsi as usual
    
 .populate:
    mov r9b, byte [rsi] 
    mov [tab+rcx], r9b
    inc rcx
    inc rsi
    cmp rcx, 13
    jl .populate

_solv:                    ; Convert input to int

 .inner:
    mov r9b, byte [rsi] 
    mov [tab+13], r9b
    inc rsi
    xor rcx, rcx

 .compute:
    mov bl, [tab+rcx]
 
    mov r8, rcx
    add r8, 1
 .l:
    cmp bl, [tab+r8] ; compare last byte to the others
    je .next
    inc r8
    cmp r8, 14
    jl .l

    inc rcx
    cmp rcx, 13
    jl .compute

    mov r9, rsi
    sub r9, input ; compute the length before the marker
    jmp _itoa

 .next:
    movaps xmm0, [tab]
    psrldq xmm0, 1
    movdqu [tab], xmm0
    jmp .inner

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