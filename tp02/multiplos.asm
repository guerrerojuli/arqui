section .text

global _start
extern numtostr
extern exit

; =========================================================================
; _start: Punto de entrada
; =========================================================================
_start:
        xor     ecx, ecx        ; ecx = 0
        mov     ebx, n          ; ebx = 10 (divisor)

.loop:
        inc     ecx             ; ecx++
        cmp     ecx, k          ; ¿ecx >= k?
        jge     .done           ; si sí, saltamos a .done

        ; 1) Preparar el dividendo de 64 bits en EDX:EAX
        xor     edx, edx        ; edx = 0 (parte alta del dividendo)
        mov     eax, ecx        ; eax = ecx (parte baja del dividendo)

        ; 2) Dividir: (EDX:EAX) / EBX
        div     ebx             ; resultado en EAX, resto en EDX

        cmp     edx, 0          ; ¿resto == 0?
        jne     .loop           ; si no es cero, seguir incrementando ecx

        ; Si el resto == 0 => ecx es múltiplo de n
        ; Llamada a numtostr(ecx) usando cdecl:
        push    ecx             ; argumento en la pila
        call    numtostr        ; numtostr devuelve (normalmente) puntero en EAX
        add     esp, 4          ; restaurar la pila

        ; (Si quisieras imprimir el string devuelto, 
        ;  tendrías que hacer push eax y llamar a otra función, etc.)

        jmp     .loop

.done:
        ; Llamar a exit(0) con convención cdecl
        push    0               ; código de salida = 0
        call    exit
        add     esp, 4          ; limpiar la pila tras la llamada

section .data
n equ 10
k equ 70

