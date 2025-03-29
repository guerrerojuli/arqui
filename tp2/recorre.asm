section .text
global _start

extern print
extern exit

_start:
    	mov ebp, esp
    	inc ebp               ; Me salteo argc
    	xor eax, eax

.loop: 	cmp ebp, 0
    	je .is_null
    	mov ebx, ebp
    	call print

.next:	add ebp, 4
    	jmp .loop

.is_null:
    	cmp eax, 0
    	jne .end
	inc eax
    	call print

.end: 	call exit
