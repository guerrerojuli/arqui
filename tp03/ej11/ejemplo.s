
main:
	push ebp
	mov ebp, esp
	and esp, -16
	sub esp, 32
	mov DWORD PTR [esp+19], 1819043176
	mov DWORD PTR [esp+23], 1870078063
	mov DWORD PTR [esp+27], 174353522
	mov BYTE PTR [esp+31], 0
	lea eax, [esp+19]
	mov DWORD PTR [esp], eax
	call magia
	lea eax, [esp+19]
	mov DWORD PTR [esp], eax
	call printf
	mov eax, 0
	leave

magia:
	push ebp
	mov ebp, esp

	sub esp, 16
	jmp .L4
.L6:
	mov eax, DWORD PTR [ebp+8]
	movzx eax, BYTE PTR [eax]
	cmp al, 96
	jle .L5
	mov eax, DWORD PTR [ebp+8]
	movzx eax, BYTE PTR [eax]
	cmp al, 122
	jg .L5
	mov eax, DWORD PTR [ebp+8]
	movzx eax, BYTE PTR [eax]
	mov BYTE PTR [ebp-1], al
	movzx eax, BYTE PTR [ebp-1]
	sub eax, 32
	mov BYTE PTR [ebp-1], al
	mov eax, DWORD PTR [ebp+8]
	movzx edx, BYTE PTR [ebp-1]
	mov BYTE PTR [eax], dl
.L5:
	add DWORD PTR [ebp+8], 1
.L4:
	mov eax, DWORD PTR [ebp+8]
	movzx eax, BYTE PTR [eax]
	test al, al
	jne .L6
	leave
	ret
