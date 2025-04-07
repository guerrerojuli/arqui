section .data
  msg db "Fibonacci number of %s is %d", 10, 0
  error_msg db "Usage: %s <n>", 10, 0

section .text
  global main
  extern atoi, exit, printf

main:
  push ebp
  mov ebp, esp

  mov ebx, [ebp + 8]    ; argc
  cmp ebx, 2
  jne .error

  mov eax, [ebp + 12]   ; argv (char**)
  push dword [eax + 4]  ; argv[1]
  call atoi             ; atoi(argv[1]) -> eax = n (int)
  add esp, 4

  push eax
  call fibo
  add esp, 4

  push eax
  mov edx, [ebp + 12]   ; argv (char**)
  push dword [edx + 4]  ; argv[1]
  push msg
  call printf
  add esp, 4

.exit:
  mov ebx, 0
  call exit

.error:
  mov eax, [ebp + 12]   ; argv (char**)
  push dword [eax]
  push error_msg
  call printf
  add esp, 2*4

  mov ebx, 1
  call exit

  

fibo:
  push ebp
  mov ebp, esp
  push ebx               ; Save EBX because is used recursively

  mov eax, [ebp + 8]
  cmp eax, 2
  jl .return             ; n < 2 -> fibo(n) = n

  dec eax               ; n - 1
  push eax
  call fibo             ; fibo(n-1)
  add esp, 4
  mov ebx, eax

  mov eax, [ebp + 8]
  sub eax, 2            ; n - 2
  push eax
  call fibo             ; fibo(n-2)
  add esp, 4
  add eax, ebx          ; fibo(n-1) + fibo(n-2)
  jmp .return

.return:
  pop ebx                ; Restore EBX
  mov esp, ebp
  pop ebp
  ret
