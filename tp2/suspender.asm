section .data
timespec:        ; Estructura timespec
    dd 5         ; tv_sec = 5 (segundos)
    dd 0         ; tv_nsec = 0 (nanosegundos)

section .text
global _start

extern exit

_start:
    	mov ebx, timespec
	call sleep
	call exit


; Recibe por EBX es puntero al timespec
; EBX = puntero a timespec (req = { tv_sec=5, tv_nsec=0 })
sleep:
	push eax
	push ecx
	mov eax, 162	; EAX = 162 -> syscall nanosleep (en x86 32 bits)
	xor ecx, ecx	; ECX = puntero a timespec para "remaining" (NULL => 0)
	int 0x80
	pop ecx
	pop eax
	ret
