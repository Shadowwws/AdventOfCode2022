n%define SYS_EXIT 60
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
tab: db 0,0,0,0

section .text
global _start
_start:

    mov rsi, input ; input in rsi as usual
    xor rax, rax ; prep eax to use it as a 4 bytes array to keep track of the 4 last characters
    movzx rbx, byte [rsi]
    add rax, rbx
    shl eax, 8 ; shift left of 8 bits to add nex value
    inc rsi
    movzx rbx, byte [rsi]
    add rax, rbx
    shl eax, 8
    inc rsi
    movzx rbx, byte [rsi]
    add rax, rbx
    shl eax, 8
    inc rsi
_solv:                    ; Convert input to int

 .inner:
    movzx ebx, byte [rsi]
    add eax, ebx
    inc rsi

 .compute:
    mov [tab], eax ; mov eax in an array to use the indices 
    mov bl, [tab]

    cmp bl, [tab+1] ; compare last byte to the others
    je .next
    cmp bl, [tab+2]
    je .next
    cmp bl, [tab+3]
    je .next

    mov bl, [tab+1]
    cmp bl, [tab+2] ; compare next byte
    je .next
    cmp bl, [tab+3]
    je .next
    mov bl, [tab+2]
    cmp bl  , [tab+3] ; compare nex byte
    je .next
    mov r9, rsi
    sub r9, input ; compute the length before the marker
    jmp _itoa

 .next:
    shl eax, 8 ; remove the old character ( works like FIFO )
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