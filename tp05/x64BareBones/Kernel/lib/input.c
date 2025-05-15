#include "keyboard.h" // Assuming keyboard.h is in the include path

// Basic scancode to ASCII mapping for US QWERTY layout (press events only)
// This is a simplified map and doesn't handle shift, caps, or special keys yet.
static const char scancode_to_ascii_map[128] = {
    0,    27,  '1',  '2',  '3',  '4',  '5',  '6',  '7',  '8',  '9',  '0',  '-',  '=', '\b', // 0x00 - 0x0E (Backspace)
 '\t',  'q',  'w',  'e',  'r',  't',  'y',  'u',  'i',  'o',  'p',  '[',  ']', '\n', // 0x0F - 0x1C (Enter)
    0,   'a',  's',  'd',  'f',  'g',  'h',  'j',  'k',  'l',  ';', '\'',  '`',    0,   // 0x1D - 0x2A (Left Shift)
 '\\',  'z',  'x',  'c',  'v',  'b',  'n',  'm',  ',',  '.',  '/',    0,    '*',   // 0x2B - 0x37 (Keypad *)
    0,   ' ',    0,                                                                  // 0x38 (Left Alt), 0x39 (Space), 0x3A (Caps Lock)
    // ... many more scancodes would go here ...
    // For simplicity, filling the rest with 0
    // F1-F10, NumLock, ScrollLock, Keypad keys, etc. are not mapped.
};


char get_char(void) {
    unsigned char scancode;
    scancode = kb_flag(); // Call the assembly function to get a scancode

    // Basic bounds check for our simplified map
    if (scancode < sizeof(scancode_to_ascii_map) / sizeof(scancode_to_ascii_map[0])) {
        return scancode_to_ascii_map[scancode];
    }
    return 0; // Return null char if scancode is out of bounds or not mapped
} 