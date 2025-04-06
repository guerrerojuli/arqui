// exit, sys_read, sys_write, sys_open, sys_close
// read and print line by line
#include <stdio.h>

#define BUFFER_SIZE 30

void exit(int status);
void sys_read(int fd, void *buffer, int length);
void sys_write(int fd, void *buffer, int length);
int sys_open(char *filename, int flags, int mode);
void sys_close(int fd);

int main(int argc, char **argv) {
  if (argc != 2) {
    printf("Usage: %s <filePath>\n", argv[0]);
    exit(1);
  }

  char *filePath = argv[1];

  int fd;
  char buffer[BUFFER_SIZE];

  fd = sys_open(filePath, 0, 0);
  sys_read(fd, buffer, BUFFER_SIZE);
  sys_write(1, buffer, BUFFER_SIZE);
  puts("");
  sys_close(fd);

  exit(0);
}
