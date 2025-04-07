; This function transforms "Hello World" to "HELLO WORLD" and prints it

main:
	push ebp  ; Stack frame 
	mov ebp, esp
	and esp, -16  ; Align stack
	sub esp, 32  ; Reserve space for local variables
	mov DWORD PTR [esp+19], 1819043176  ; "Hello World\n"
	mov DWORD PTR [esp+23], 1870078063
	mov DWORD PTR [esp+27], 174353522
	mov BYTE PTR [esp+31], 0
	lea eax, [esp+19] ; move to eax the address of the string
	mov DWORD PTR [esp], eax  ; move to the stack the address of the string
	call magia  ; call the function
	lea eax, [esp+19] ; move to eax the return value
	mov DWORD PTR [esp], eax  ; move to the stack the return value
	call printf ; print the string
	mov eax, 0  ; return 0
	leave

magia:
	push ebp  ; Stack frame
	mov ebp, esp

	sub esp, 16 ; Reserve space for local variables
	jmp .L4
.L6:
	mov eax, DWORD PTR [ebp+8]  ; move to eax the address of the string
	movzx eax, BYTE PTR [eax] ; move to eax the character of the string
	cmp al, 96  ; jmp if the character is less than 'a'
	jle .L5
	mov eax, DWORD PTR [ebp+8] ; move to eax the address of the string
	movzx eax, BYTE PTR [eax] ; move to eax the character of the string
	cmp al, 122 ; jmp if the character is greater than 'z'
	jg .L5
	mov eax, DWORD PTR [ebp+8]
	movzx eax, BYTE PTR [eax]
	mov BYTE PTR [ebp-1], al  ; move to ebp-1 the character of the string (a local char variable)
	movzx eax, BYTE PTR [ebp-1] ; move to eax the character of the string
	sub eax, 32 ; convert to uppercase
	mov BYTE PTR [ebp-1], al  ; save the uppercase character on the local variable
	mov eax, DWORD PTR [ebp+8]  ; move to eax the address of the string
	movzx edx, BYTE PTR [ebp-1] ; move to edx the uppercase character
	mov BYTE PTR [eax], dl  ; save the uppercase character on the string
.L5:
	add DWORD PTR [ebp+8], 1  ; move to the next character
.L4:
	mov eax, DWORD PTR [ebp+8]  ; move to eax the address of the string
	movzx eax, BYTE PTR [eax] ; move to eax the character of the string
	test al, al
	jne .L6 ; jump if the character is not null
	leave
	ret
