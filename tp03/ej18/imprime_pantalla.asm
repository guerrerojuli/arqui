section .data
error_msg db "Los tamaños de encabezado y pie deben ser de 1 a 80", 10, 0

section .text
global imprime_pantalla

extern puts

; int imprime_pantalla(char *encabezado, int tam_enc, char *pie, int tam_pie);
; 1 <= tam <= 80
; [ebp+8] encabezado
; [ebp+12] tam_enc
; [ebp+16] pie
; [ebp+20] tam_pie

imprime_pantalla:
  ; Stack frame
  push ebp
  mov ebp, esp

  ; Params
  ; TODO encabezado

  cmp dword [ebp + 20], 1
  jl .error
  cmp dword [ebp + 20], 80
  jg .error

  push dword [ebp + 16]
  call puts
  add esp, 4

  jmp .success
 
 
.error: 
  push error_msg
  call puts
  add esp, 4
  
  ; Return
  mov eax, 1
  jmp .return

.success:
  mov eax, 0

.return:
  mov esp, ebp
  pop ebp
  ret
