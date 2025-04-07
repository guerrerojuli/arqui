section .data
  msg: db "Manufacurer ID: %s", 10, 0

section .bss
  manufacturer_id: resb 12

section .text
  global main

  extern printf

main:
  call cpu_id

  mov eax, 1
  mov ebx, 0
  int 0x80

cpu_id:
  push ebp
  mov ebp, esp

  xor eax, eax
  cpuid

  mov [manufacturer_id], ebx
  mov [manufacturer_id+4], edx
  mov [manufacturer_id+8], ecx

  push manufacturer_id
  push msg
  call printf

  add esp, 2*4

  mov esp, ebp
  pop ebp
  ret
