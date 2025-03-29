section .data
    ; Arreglo original (6 elementos de 4 bytes)
    array:      dd 20, 9, 11, 23, 42, 34
    array_len:  equ ($ - array) / 4
    dest times 10 db 0           ; Buffer para la conversión a cadena
    newline:    db 10            ; Salto de línea
    space:	db ' '		 ; Espacio 
    max_val     equ 0x7fffffff   ; Valor centinela (máximo)

section .text
global _start

_start:
sort_loop:
    ; Llamamos a find_min para obtener el mínimo del arreglo completo
    mov esi, array          ; ESI apunta al inicio del arreglo
    mov ecx, array_len      ; ECX = cantidad de elementos
    call find_min           ; Resultado: mínimo en EAX

    ; Si el mínimo es el valor centinela, es que ya procesamos todos los elementos
    cmp eax, max_val
    je sorting_done

    ; Buscar la primera ocurrencia del valor mínimo para “marcarlo”
    mov edi, array          ; EDI apuntará a cada elemento del arreglo
find_index:
    cmp dword [edi], eax
    je mark_element
    add edi, 4
    jmp find_index

mark_element:
    mov dword [edi], max_val    ; Marcamos el elemento como extraído

    ; Convertir el número mínimo a cadena y luego imprimirlo
    mov ecx, eax          ; Número a convertir
    mov edi, dest         ; Buffer destino para la conversión
    call num2str

    ; Imprimir la cadena resultante
    mov eax, 4            ; sys_write
    mov ebx, 1            ; STDOUT
    mov ecx, dest
    mov edx, 10           ; longitud máxima del buffer
    int 0x80

    ; Imprimir espacio
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80

    jmp sort_loop

sorting_done:
    ; Imprimir salto de línea
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

; ------------------------------------------------------------
; find_min:
;   Entrada:
;       ESI → puntero al inicio del arreglo.
;       ECX = cantidad de elementos (cada uno de 4 bytes).
;   Salida:
;       EAX = valor mínimo encontrado.
; ------------------------------------------------------------
find_min:
    ; Se asume que el arreglo tiene al menos un elemento.
    mov eax, [esi]         ; Valor mínimo inicial = primer elemento
    add esi, 4             ; Avanzamos al siguiente elemento
    dec ecx                ; Ya se procesó el primero
.find_loop:
    cmp ecx, 0
    je .done
    mov edx, [esi]         ; Elemento actual en EDX
    cmp eax, edx
    jle .skip              ; Si eax <= edx, se conserva el mínimo
    mov eax, edx           ; Actualiza mínimo
.skip:
    add esi, 4
    dec ecx
    jmp .find_loop
.done:
    ret

; ------------------------------------------------------------
; num2str:
;   Convierte el número en ECX a ASCII, escribiendo la cadena en [EDI].
;   Maneja números negativos (coloca '-' al inicio) y el caso del cero.
;   Escribe los dígitos en orden inverso y luego los revierte in-situ.
;   Finaliza la cadena con 0.
; ------------------------------------------------------------
num2str:
    push ebp
    mov  ebp, esp

    ; 1) Manejar signo negativo
    cmp ecx, 0
    jge .positive
    neg ecx
    mov byte [edi], '-'
    inc edi            ; EDI apunta después del signo

.positive:
    ; 2) Caso especial para cero
    cmp ecx, 0
    jne .loop_start
    mov byte [edi], '0'
    inc edi
    jmp .done

.loop_start:
.loop:
    xor edx, edx       ; Limpiar EDX para división
    mov eax, ecx
    mov ebx, 10
    div ebx            ; EAX = cociente, EDX = residuo
    add dl, '0'        ; Convertir residuo a carácter ASCII
    mov [edi], dl      ; Guardar dígito
    inc edi
    mov ecx, eax       ; Actualiza ECX con el cociente
    test ecx, ecx
    jnz .loop

.done:
    ; Terminar la cadena
    mov byte [edi], 0

    ; 3) Revertir la cadena de dígitos (dejando el signo '-' intacto si existe)
    mov esi, dest      ; ESI apunta al inicio del buffer
    mov al, [esi]
    cmp al, '-'
    jne .do_reverse
    inc esi            ; Si hay signo, saltarlo

.do_reverse:
    dec edi            ; EDI apunta al último dígito (antes del 0)
.reverse_loop:
    cmp esi, edi
    jge .reverse_done  ; Terminar si se cruzan o se encuentran
    mov al, [esi]      ; Intercambiar [esi] y [edi]
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al
    inc esi
    dec edi
    jmp .reverse_loop

.reverse_done:
    pop ebp
    ret

