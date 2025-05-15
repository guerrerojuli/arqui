#ifndef KEYBOARD_H
#define KEYBOARD_H

// Reads a scancode and converts it to an ASCII character.
// Returns 0 if the scancode is not recognized or is a non-printable key.
char get_char(void);

#endif // KEYBOARD_H 