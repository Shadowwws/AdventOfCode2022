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
tab: TIMES 200 db 0

section .text
global _start
_start:

    mov rsi, input
    xor r9, r9 ; The total sum
    mov rcx, 2 ; to divide in the middle
    mov r14, tab ; to save our first input line
    xor r10, r10 ; counter for the group of 3

 .l:
    mov r15b, byte [rsi] ; move current character into r15
    mov byte [r14], r15b ; move it into our array
    inc r14
    inc rsi
    cmp byte [rsi], 10 ; compare if we're at the end of the line
    jne .l
    inc r10 ; one more
    cmp r10, 3 ; we have our 3 elves
    je .compute
    push r14 ; save the address of the beginning of the elf 
    inc rsi ; skip the \n
    jmp .l    

 .outer:
    inc rsi ; next line
    cmp rsi, inputend ; check for end
    jae _itoa
    mov r14, tab
    pop r12 ; reset the stack
    pop r12
    pop r12
    xor r10, r10
    jmp .l ; loop

 .compute:
    push r14
    mov r14, tab ; line in r14
    mov r12, [rsp+16] ; address of the beginning of the second elf
    mov r13, [rsp+8] ; address of the beginning of the third elf
    mov r8b , byte [r14] ; move first char
    jmp .second
  
  .first:
    inc r14
    mov r8b, byte [r14]
    cmp r14, [rsp+16]

  .second: ; test the current char from first elf (in r8b) with all the ones in the second elf, if found => look at the thirs one
    cmp r8b, byte [r12]
    je .third
    inc r12
    cmp r12, [rsp+8]
    jl .second
    mov r12, [rsp+16]
    jmp .first

  .third: ; test if the char is in the third one
    cmp r8b, byte [r13]
    je .found
    inc r13
    cmp r13, [rsp]
    jl .third
    mov r12, [rsp+16] ; reset the pointer to the second elf for the next chat from the first elf
    mov r13, [rsp+8] ; same for third
    jmp .first

 .found:
    cmp r8b, "a" ; check if it's lowercase or uppercase
    jae .min
    movzx r13, r8b
    add r9, r13
    sub r9, 38 ; add ascii value minus 38 in case of uppercase
    jmp .outer

  .min:
    movzx r13, r8b
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