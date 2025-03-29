section .text
global _start

extern print
extern exit

_start:
	mov eax, [esp]
	mov ebp, esp
	add ebp, 4
	call print_args

	call exit


print_args:
	cmp eax, 0
	jle .done
	mov ebx, [ebp]
	call print
	mov ebx, blank
	call print
	add ebp, 4
	dec eax
	jmp print_args
.done: 	mov ebx, newline
	call print
	ret

section .data
newline db 10
blank db " "
