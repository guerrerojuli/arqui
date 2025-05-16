#include <keyboard.h>
#include <io.h>
#include <stdint.h>
#include <naive_console.h>

// Simple tabla de scancodes a ASCII (modo US, sin shift)
static const char scancode_to_ascii[128] = {
    0,  27, '1','2','3','4','5','6','7','8','9','0','-','=','\b',
    '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n',
    0,  'a','s','d','f','g','h','j','k','l',';','\'','`', 0,
    '\\','z','x','c','v','b','n','m',',','.','/', 0,  '*', 0,
    ' ', /* resto inicializado a 0 */
};

// This is the C part of the keyboard interrupt handler
void keyboard_handler(void) {
    uint8_t sc = inb(0x60);
    if (sc < sizeof(scancode_to_ascii) && scancode_to_ascii[sc]) {
        switch (scancode_to_ascii[sc]) {
            case '\n':
                nc_newline();
                break;
            case '\b':
                nc_backspace();
                break;
            case '\t':
                nc_print("  ");
                break;
            default:
                nc_print_char(scancode_to_ascii[sc]);
                break;
        }
    }
    // Send End Of Interrupt (EOI) to Master PIC
    outb(0x20, 0x20);
}
 