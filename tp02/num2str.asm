section .text
    global _start

_start:
    ; Load number into ECX, load buffer address into EDI
    mov ecx, [num]
    mov edi, dest

    ; Convert ECX → string at [dest]
    call num2str

    ; Print the string
    mov eax, 4        ; sys_write
    mov ebx, 1        ; file descriptor = stdout
    mov ecx, dest     ; pointer to our string
    mov edx, 10       ; max length to print (enough for our buffer)
    int 0x80

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

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

section .data
num  dd  -572               ; Example number
dest times 10 db 0         ; 10-byte buffer (enough for sign + digits + null)

