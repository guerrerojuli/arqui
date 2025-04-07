section .text
global check_long

check_long:
    push ebp
    mov ebp, esp
    sub esp, 4

    mov ecx, [ebp+8]  ; string

    xor eax, eax
.loop:
    cmp byte [ecx], 0
    je .end
    inc ecx
    inc eax
    jmp .loop

.end:
    sub eax, [ebp+12] ; length - expected length

    mov esp, ebp
    pop ebp
    ret


