section .data
    msg db "PID: ", 0
    pid_str db 10 dup(0) ; espacio para el PID en ASCII

section .text
    global _start

_start:
    ; syscall: getpid -> eax = 20
    mov eax, 20
    int 0x80
    mov ebx, eax          ; guardar el PID en ebx

    ; Convertir número (ebx) a string decimal
    mov ecx, pid_str + 9  ; puntero al final del buffer
    mov byte [ecx], 0     ; null terminator

.to_ascii:
    dec ecx
    xor edx, edx
    mov eax, ebx
    mov esi, 10
    div esi               ; eax / 10 -> eax=cociente, edx=resto
    add dl, '0'
    mov [ecx], dl
    mov ebx, eax
    test eax, eax
    jnz .to_ascii

    ; Escribir "PID: "
    mov eax, 4            ; syscall: write
    mov ebx, 1            ; fd = stdout
    mov ecx, msg
    mov edx, 5            ; longitud de "PID: "
    int 0x80

    ; Escribir el PID
    mov eax, 4
    mov ebx, 1
    mov edx, pid_str + 9
    sub edx, ecx          ; longitud = &fin - &inicio
    mov edx, edx
    int 0x80

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

