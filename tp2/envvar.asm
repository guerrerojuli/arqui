section .text
global _start

extern print
extern exit

_start:
    ; Calcular la dirección de envp[0]:
    ; La pila al inicio contiene:
    ; [esp]         = argc
    ; [esp+4]       = argv[0]
    ; [esp+4*argc]  = último argv
    ; [esp+4*(argc+1)] = NULL (fin de argv)
    ; [esp+4*(argc+2)] = envp[0]
    mov eax, [esp]       ; eax = argc
    add eax, 2           ; (argc + 2)
    mov ebp, esp
    shl eax, 2           ; (argc+2)*4 bytes
    add ebp, eax        ; ebp apunta a envp[0]

search_env:
    mov esi, [ebp]       ; esi = puntero a la variable de entorno actual
    test esi, esi
    jz done              ; Si llega a NULL, no se encontró -> salir

    mov edi, env_param   ; edi apunta a la cadena "USER"
    
    ; Guarda la posición de inicio de la cadena actual para usarla en caso de éxito,
    ; pero aquí no la necesitamos porque imprimiremos solo lo que sigue al '='.
    ; Compara la variable de entorno con "USER"
compare_loop:
    mov al, [edi]      ; obtener el siguiente carácter de env_param
    cmp al, 0
    je check_equal     ; si terminamos de comparar "USER", verificamos el '='
    cmp al, [esi]      ; compara carácter actual con el de la variable de entorno
    jne next           ; si no coincide, saltar a la siguiente variable
    inc edi            ; avanza en env_param
    inc esi            ; avanza en la cadena de la variable de entorno
    jmp compare_loop

check_equal:
    cmp byte [esi], '=' ; verificamos que el siguiente carácter sea '='
    jne next          ; si no, no es la variable buscada
    inc esi           ; saltamos el '=' para que esi apunte al nombre de usuario
    mov ebx, esi      ; preparamos ebx para print (la función print asume cadena nula)
    call print

    mov ebx, newline
    call print

    jmp done        ; Salir inmediatamente

next:
    add ebp, 4      ; avanzar al siguiente puntero de envp
    jmp search_env

done:
    call exit

section .data
newline   db 10, 0
env_param db "USER", 0

