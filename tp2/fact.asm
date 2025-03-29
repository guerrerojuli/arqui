section .data
dest times 10 db 0
n equ 10

section .text
global _start

_start:	mov ebx, n
	call fact

	mov ecx, eax
	mov edi, dest
	call num2str

	mov eax, 4
	mov ebx, 1
	mov ecx, dest
	mov edx, 10
	int 0x80

	jmp exit


fact:	mov ecx, 0
	mov eax, 1
	mov ecx, ebx

.loop:	test ecx, ecx	
	jz .done

	mul ecx
	dec ecx
	jmp .loop

.done:	ret


; ---------------------------------------------------
; num2str: 
;   Converts integer in ECX → ASCII at [EDI].
;   1) Handles negative numbers (leading '-').
;   2) Writes digits in reverse.
;   3) Reverses them in-place for correct order.
; ---------------------------------------------------
num2str:
    push ebp
    mov  ebp, esp

    ; 1) Check sign
    cmp ecx, 0
    jge .positive
    neg ecx
    mov byte [edi], '-'
    inc edi            ; EDI now points after '-'

.positive:
    ; 2) Handle zero as a special case
    cmp ecx, 0
    jne .loop_start
    mov byte [edi], '0'
    inc edi
    jmp .done

.loop_start:
.loop:
    ; Remainder in EDX → one digit
    xor edx, edx       ; Clear EDX before division
    mov eax, ecx
    mov ebx, 10
    div ebx            ; EAX = quotient, EDX = remainder
    add dl, '0'        ; Convert remainder to ASCII
    mov [edi], dl      ; Store digit
    inc edi

    mov ecx, eax       ; Keep dividing until 0
    test ecx, ecx
    jnz .loop

.done:
    ; 3) Terminate string with 0
    mov byte [edi], 0

    ; 4) Reverse digits in-place, but skip any leading '-'
    ;    (so '-' remains at the front).
    ; 
    ;    EDI is currently one past the last digit (or 0).
    mov esi, dest      ; ESI → start of buffer
    mov al, [esi]      ; Check if there's a '-'
    cmp al, '-'
    jne .do_reverse
    inc esi            ; skip '-'

.do_reverse:
    dec edi            ; EDI now points to the last character of the digits
.reverse_loop:
    cmp esi, edi
    jge .reverse_done  ; stop if pointers cross or meet

    mov al, [esi]      ; swap [esi] ↔ [edi]
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al

    inc esi
    dec edi
    jmp .reverse_loop

.reverse_done:
    pop ebp
    ret


exit:	mov eax, 1
	xor ebx, ebx
	int 0x80
