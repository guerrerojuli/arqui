GLOBAL exit
GLOBAL sys_read
GLOBAL sys_write
GLOBAL sys_open
GLOBAL sys_close


ALIGN 4
exit:
  push ebp
  mov ebp, esp

  mov eax, 1
  mov ebx, [ebp + 8]
  int 0x80

sys_read:
  push ebp
  mov ebp, esp

  push ebx ;preservar ebx

  mov eax, 0x3
  mov ebx, [ebp+8] ;fd
  mov ecx, [ebp+12] ;buffer
  mov edx, [ebp+16] ;length
  int 0x80


  pop ebx

  mov esp, ebp
  pop ebp
  ret

sys_write:
  push ebp
  mov ebp, esp

  push ebx ;preservar ebx

  mov eax, 0x4
  mov ebx, [ebp+8] ;fd
  mov ecx, [ebp+12] ;buffer
  mov edx, [ebp+16] ;length
  int 0x80

  pop ebx

  mov esp, ebp
  pop ebp
  ret

sys_open:
  push ebp
  mov ebp, esp

  push ebx ;preservar ebx

  mov eax, 0x5
  mov ebx, [ebp+8] ;filename
  mov ecx, [ebp+12] ;flags
  mov edx, [ebp+16] ;mode
  int 0x80

  pop edx

  mov esp, ebp
  pop ebp
  ret

sys_close:
  push ebp
  mov ebp, esp
  
  mov eax, 0x6
  mov ebx, [ebp+8]
  int 0x80
  
  mov esp, ebp
  pop ebp
  ret
