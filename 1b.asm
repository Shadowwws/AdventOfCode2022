%define SYS_EXIT 60
%define SYS_WRITE 1
%define STDOUT 1
%define SYS_READ 0
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define STDIN 0

section .rodata
input:
  incbin "1.in"
inputend:

section .text
global _start
_start:

    mov rsi, input
    xor r9, r9
    xor r10, r10 ; Greater number of calories
    xor r11, r11 ; Second greater
    xor r12, r12 ; Third greater
    push 0

_atoi:                    ; Convert input to int

 .setup:
    xor eax, eax

 .inner:
    imul rax, 10
    movzx rbx, byte [rsi]
    add rax, rbx
    sub rax, 48
    inc rsi
    cmp byte [rsi], 10
    jne .inner
    push rax ; add the new read number to the stack 
    inc rsi
    cmp rsi, inputend
    jae .end
    cmp byte [rsi], 10 ; We finished our Elf, all its calories are on the stack
    je .sum
    jmp .setup
    
 .end:

    mov r9, r10 ; Making the sum of the 3 greatest in r9 for printing
    add r9, r11
    add r9, r12
    jmp _itoa

 .sum: ; Start making the sum of all the calories of the Elf
    inc rsi
    pop r8

 .l: ; The actual loop, popping from the stack until the 0 placed at the beginning
    cmp dword [rsp], 0
    je .sum_done
    pop r9
    add r8, r9
    jmp .l

 .sum_done: ; Sum is done, compare to previous max and replace if greater, doing a cascade to change the 3 when nevessary
    cmp r8, r10
    cmova r12, r11
    cmova r11, r10
    cmova r10, r8
    ja .test_end
    cmp r8, r11
    cmova r12, r11
    cmova r11, r8
    ja .test_end
    cmp r8, r12
    cmova r12, r8

 .test_end:
    cmp rsi, inputend
    jae .end
    jmp .setup


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