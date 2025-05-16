#include <stdint.h>
#include <drivers/idt/syscalls.h>

#define SYSCALL_WRITE 1

void syscallDispatcher(uint64_t syscall_number, uint64_t arg1, uint64_t arg2, uint64_t arg3) {
  switch (syscall_number) {
    case SYSCALL_WRITE:
      syscall_write(arg1, (char *)arg2, arg3);
      break;
  }
}