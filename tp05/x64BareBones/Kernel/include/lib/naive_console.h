#ifndef NAIVE_CONSOLE_H
#define NAIVE_CONSOLE_H

#include <stdint.h>

void nc_print(const char * string);
void nc_print_styled(const char * string, char background, char foreground);
void nc_print_char(char character);
// 0x0 -> Black, 0x1 -> Blue, 0x2 -> Green 
// 0x3 -> Cyan, 0x4 -> Red, 0x5 -> Magenta 
// 0x6 -> Brown, 0x7 -> Light Gray, 0x8 -> Dark Gray
// 0x9 -> Light Blue, 0xA -> Light Green, 0xB -> Light Cyan
// 0xC -> Light Red, 0xD -> Light Magenta, 0xE -> Yellow
// 0xF -> White
void nc_print_styled_char(char character, char background, char foreground);
void nc_newline();
void nc_print_dec(uint64_t value);
void nc_print_hex(uint64_t value);
void nc_print_bin(uint64_t value);
void nc_print_base(uint64_t value, uint32_t base);
void nc_clear();
void nc_backspace();

#endif