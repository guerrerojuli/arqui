#include <stdint.h>
#include <naive_console.h>
#include <drivers/idt/syscalls.h>

#define STDOUT 1
#define STDERR 2


void syscall_write(uint64_t fd, char *buffer, uint64_t count) {
  uint8_t color = (fd == STDOUT) ? 0x7 : 0x4;
  for (uint64_t i = 0; i < count; i++) {
    nc_print_styled_char(buffer[i], 0x0, color);
  }
}