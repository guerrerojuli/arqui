section .data
    ; Definición del arreglo y cálculo de su longitud en elementos
    array:      dd 20, 9, 11, 23, 42, 34
    array_len:  equ ($ - array) / 4
    dest times 10 db 0        ; Buffer para almacenar la cadena (mínimo 10 bytes)

section .text
global _start
extern exit

_start:
    ; --- Llamada a find_min para obtener el mínimo ---
    mov esi, array          ; ESI apunta al inicio del arreglo
    mov ecx, array_len      ; Cantidad de elementos
    call find_min           ; Resultado: mínimo en EAX

    ; --- Conversión del número mínimo a cadena ---
    mov ecx, eax           ; Coloca el número mínimo en ECX para num2str
    mov edi, dest          ; EDI apunta al buffer de destino
    call num2str

    ; --- Impresión del resultado ---
    mov eax, 4             ; syscall sys_write
    mov ebx, 1             ; descriptor STDOUT
    mov ecx, dest          ; cadena a imprimir
    mov edx, 10            ; longitud máxima del buffer
    int 0x80

    ; --- Salida del programa ---
    call exit

; ------------------------------------------------------------
; find_min:
;   Entrada:
;       ESI → puntero al primer elemento del arreglo.
;       ECX = cantidad de elementos del arreglo.
;   Salida:
;       EAX = valor mínimo encontrado.
; ------------------------------------------------------------
find_min:
    ; Se asume que el arreglo tiene al menos un elemento.
    mov eax, [esi]         ; Valor mínimo inicial = primer elemento
    add esi, 4             ; Avanza al siguiente elemento
    dec ecx                ; Se ya procesó el primer elemento
.find_loop:
    cmp ecx, 0
    je .done               ; Si no quedan elementos, salimos
    mov edx, [esi]         ; Carga el elemento actual en EDX
    cmp eax, edx
    jle .skip              ; Si EAX <= elemento actual, sigue
    mov eax, edx           ; Actualiza el mínimo si es mayor
.skip:
    add esi, 4             ; Avanza al siguiente elemento
    dec ecx
    jmp .find_loop
.done:
    ret

; ------------------------------------------------------------
; num2str:
;   Convierte el número en ECX a ASCII, escribiendo la cadena en [EDI].
;   Maneja números negativos (agrega '-' al inicio) y convierte dígitos en orden inverso para luego revertirlos.
;   Finaliza la cadena con 0.
; ------------------------------------------------------------
num2str:
    push ebp
    mov  ebp, esp

    ; 1) Comprobar si el número es negativo
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
    xor edx, edx       ; Limpiar EDX antes de la división
    mov eax, ecx
    mov ebx, 10
    div ebx            ; EAX = cociente, EDX = residuo
    add dl, '0'        ; Convertir residuo a ASCII
    mov [edi], dl      ; Almacenar dígito
    inc edi
    mov ecx, eax       ; Actualizar ECX con el cociente
    test ecx, ecx
    jnz .loop

.done:
    ; Terminar la cadena con 0
    mov byte [edi], 0

    ; 3) Revertir la cadena de dígitos (dejando el signo '-' en su lugar si existe)
    mov esi, dest      ; ESI apunta al inicio del buffer
    mov al, [esi]
    cmp al, '-'
    jne .do_reverse
    inc esi            ; Si hay '-', saltarlo

.do_reverse:
    dec edi            ; EDI apunta al último dígito
.reverse_loop:
    cmp esi, edi
    jge .reverse_done  ; Salir si los punteros se cruzan o son iguales
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

