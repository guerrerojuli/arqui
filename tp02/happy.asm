section .text
GLOBAL _start

_start:
    ; Initialize pointer to string and counter (length)
    mov edx, string       ; edx = pointer to the start of the string
    mov cx, length        ; cx = length of the string
    call convert_word_mayus

    ; Print the modified string
    mov ecx, string       ; pointer to string
    mov edx, length       ; string length
    mov ebx, 1            ; stdout file descriptor
    mov eax, 4            ; sys_write call
    int 80h

    ; Exit the program
    mov eax, 1
    xor ebx, ebx          ; ebx = 0
    int 80h

;----------------------------------------------
; convert_word_mayus:
;   Converts each character in the string to uppercase,
;   if it is a lowercase letter.
;   Inputs:
;     edx - pointer to the current character in the string
;     cx  - total length of the string
;----------------------------------------------
convert_word_mayus:
    xor ax, ax            ; ax = counter/index = 0
convert_loop:
    cmp ax, cx            ; if index >= length, finish conversion
    jge conversion_done
    call convert_char_mayus
    inc edx              ; move pointer to next character
    inc ax               ; increment index
    jmp convert_loop
conversion_done:
    ret

;----------------------------------------------
; convert_char_mayus:
;   Converts a lowercase character to uppercase if needed.
;   Input:
;     edx - pointer to the character
;----------------------------------------------
convert_char_mayus:
    cmp byte [edx], 'a'
    jl char_done         ; if character < 'a', do nothing
    cmp byte [edx], 'z'
    jg char_done         ; if character > 'z', do nothing
    add byte [edx], 'A'-'a'  ; convert to uppercase
char_done:
    ret

section .data
string db "h4ppy c0d1ng", 10
length equ $-string
