section .text
global _start

extern print
extern exit

_start:
    mov ebp, esp
    inc ebp               ; Me salteo argc
    xor eax, eax

.loop: 	
    cmp dword [ebp], 0
    ;je .is_null
    je .next              ; Que cuando termine se rompa todo 
    mov ebx, ebp
    call print

.next:	
    add ebp, 4
    jmp .loop

.is_null:
    cmp eax, 0
    jne .end
    inc eax
    jmp .next

.end: 	
    mov ebx, 0
    call exit
