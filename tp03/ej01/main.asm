section .rodata
fmt_arg_count: db "Cantidad de argumentos: %d", 10, 0
fmt_arg:       db "Argumento %d: %s", 10, 0

section .text
global main
extern printf

main:
    push ebp
    mov ebp, esp

    mov esi, [ebp + 8]    ; argc
    mov edi, [ebp + 12]   ; argv

    push esi
    push dword fmt_arg_count
    call printf
    add esp, 8

    xor ebx, ebx

.loop:
    cmp ebx, esi
    jge .end

    push dword [edi + 4*ebx] ; argv[i]
    push ebx                 ; i
    push fmt_arg
    call printf
    add esp, 12

    inc ebx
    jmp .loop

.end:
    mov esp, ebp
    pop ebp
    ret
