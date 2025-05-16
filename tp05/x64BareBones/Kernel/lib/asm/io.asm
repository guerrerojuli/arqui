SECTION .text

GLOBAL inb
GLOBAL outb

; uint8_t inb(uint16_t port)
; Parameters:
;   - port: The port to read from
; Returns:
;   - The byte read from the port
inb:
    xor rax, rax
    mov dx, di
    in al, dx
    ret

; void outb(uint16_t port, uint8_t value)
; Parameters:
;   - port: The port to write to
;   - value: The byte to write to the port
outb:
    mov dx, di
    mov al, sil
    out dx, al
    ret