GLOBAL rtc

extern bcd2bin

time_port equ 0x70
data_port equ 0x71

section .text

rtc:
  push rbp
  mov rbp, rsp

  push rbx

  mov rax, rdi
  out time_port, al
  in al, data_port  ; AX now has BCD value from RTC

  pop rbx

  mov rsp, rbp
  pop rbp
  ret

