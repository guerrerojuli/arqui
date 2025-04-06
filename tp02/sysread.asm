section .data
input times 10 db 0
length equ $-input

section .text
global _start

_start: 
	mov ecx, input
	mov edx, length
	call read
	call print
	call exit


read:
	push eax
	push ebx

	mov eax, 3
	mov ebx, 0
	int 80h

	pop ebx
	pop eax
	ret

print:
	push eax
	push ebx
	
	mov eax, 4
	mov ebx, 1
	int 80h

	pop ebx
	pop eax
	ret

exit:
	mov eax, 1
	mov ebx, 0
	int 80h
