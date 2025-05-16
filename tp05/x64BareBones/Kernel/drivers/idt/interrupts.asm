GLOBAL _cli
GLOBAL _sti
GLOBAL picMasterMask
GLOBAL picSlaveMask
GLOBAL haltcpu
GLOBAL _hlt

GLOBAL _syscallHandler

GLOBAL _irq00Handler
GLOBAL _irq01Handler
GLOBAL _irq02Handler
GLOBAL _irq03Handler
GLOBAL _irq04Handler
GLOBAL _irq05Handler

GLOBAL _exception0Handler

EXTERN irqDispatcher
EXTERN exceptionDispatcher
EXTERN syscallDispatcher

SECTION .text

%macro pushState 0
	push rax
	push rbx
	push rcx
	push rdx
	push rbp
	push rdi
	push rsi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
%endmacro

%macro popState 0
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rsi
	pop rdi
	pop rbp
	pop rdx
	pop rcx
	pop rbx
	pop rax
%endmacro

%macro irqHandlerMaster 1
	pushState

	mov rdi, %1 ; pasaje de parametro
	call irqDispatcher

	; signal pic EOI (End of Interrupt)
	mov al, 20h
	out 20h, al

	popState
	iretq
%endmacro



%macro exceptionHandler 1
	pushState

	mov rdi, %1 ; pasaje de parametro
	call exceptionDispatcher

	popState
	iretq
%endmacro


_hlt:
	sti
	hlt
	ret

_cli:
	cli
	ret


_sti:
	sti
	ret

picMasterMask:
	push rbp
    mov rbp, rsp
    mov ax, di
    out	21h,al
    pop rbp
    retn

picSlaveMask:
	push    rbp
    mov     rbp, rsp
    mov     ax, di  ; ax = mascara de 16 bits
    out	0A1h,al
    pop     rbp
    retn

;Syscall
_syscallHandler:
	; Preserve registers that are modified by us or by the C call,
	; and are not already saved by pushState (if we were to use it here)
	; or are not return value registers.
	; According to System V ABI: RAX, RCX, RDX, RSI, RDI, R8-R11 are caller-saved (or used for args/return).
	; RBX, RBP, R12-R15 are callee-saved.
	; We are the "caller" of syscallDispatcher. syscallDispatcher can freely modify RDI, RSI, RDX, RCX, R8, R9, RAX, R10, R11.

	pushState ; Save all general purpose registers

	; Arguments from int 0x80 are in:
	; RAX: syscall_number
	; RDI: arg1
	; RSI: arg2
	; RDX: arg3
	; R10: arg4 (not used by our current syscalls)
	; R8:  arg5 (not used by our current syscalls)
	; R9:  arg6 (not used by our current syscalls)

	; C function: void syscallDispatcher(uint64_t syscall_number, uint64_t arg1, uint64_t arg2, uint64_t arg3)
	; Expected in:                    RDI,                 RSI,            RDX,            RCX

	mov rcx, rdx ; arg3 -> rcx (4th param)
	mov rdx, rsi ; arg2 -> rdx (3rd param)
	mov rsi, rdi ; arg1 -> rsi (2nd param)
	mov rdi, rax ; syscall_number -> rdi (1st param)

	call syscallDispatcher

	popState ; Restore all general purpose registers
	iretq

;8254 Timer (Timer Tick)
_irq00Handler:
	irqHandlerMaster 0

;Keyboard
_irq01Handler:
	irqHandlerMaster 1

;Cascade pic never called
_irq02Handler:
	irqHandlerMaster 2

;Serial Port 2 and 4
_irq03Handler:
	irqHandlerMaster 3

;Serial Port 1 and 3
_irq04Handler:
	irqHandlerMaster 4

;USB
_irq05Handler:
	irqHandlerMaster 5


;Zero Division Exception
_exception0Handler:
	exceptionHandler 0

haltcpu:
	cli
	hlt
	ret



SECTION .bss
	aux resq 1