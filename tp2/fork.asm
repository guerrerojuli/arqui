section .data
child_msg   db "Soy el hijo", 10, 0
parent_msg  db "Soy el padre", 10, 0

section .text
global _start

extern print      ; función externa para imprimir un mensaje (usa ebx como parámetro)
extern exit       ; función externa para salir

_start:
    call fork
    cmp eax, 0
    je  .child            ; Si eax == 0, estamos en el hijo
    jg  .parent           ; Si eax > 0, estamos en el padre

    ; En caso de error en fork (eax < 0)
    call exit

.parent:
    call wait_child       ; El padre espera a que termine el hijo
    call print_parent     ; Imprime el mensaje "Soy el padre"
    call exit

.child:
    call print_child      ; Imprime el mensaje "Soy el hijo"
    call exit

;-----------------------------------------------
; Función fork: llama a la interrupción 0x80 con syscall 2 (fork)
fork:
    mov eax, 2            ; syscall number de fork
    int 0x80
    ret

;-----------------------------------------------
; Función wait_child: espera a que finalice el hijo usando waitpid
wait_child:
    push ebx
    push ecx
    push edx
    mov ebx, -1           ; -1: espera cualquier proceso hijo
    mov ecx, 0            ; puntero a status (NULL)
    mov edx, 0            ; opciones = 0
    mov eax, 7            ; syscall number de waitpid
    int 0x80
    pop edx
    pop ecx
    pop ebx
    ret

;-----------------------------------------------
; Función print_parent: imprime el mensaje del padre
print_parent:
    push ebx
    mov ebx, parent_msg
    call print
    pop ebx
    ret

;-----------------------------------------------
; Función print_child: imprime el mensaje del hijo
print_child:
    push ebx
    mov ebx, child_msg
    call print
    pop ebx
    ret

