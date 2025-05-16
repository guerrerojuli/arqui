#ifndef SYSCALLS_H_
#define SYSCALLS_H_

#include <stdint.h>

void syscall_write(uint64_t fd, char *buffer, uint64_t count);

#endif
  