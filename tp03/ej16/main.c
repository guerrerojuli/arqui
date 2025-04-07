#include <stdio.h>

int check_long(char *s, int n);

int main(void) {
    char s[] = "Hola Mundo";
    int n = 10;
  
    int status = check_long(s, n);
    if (!status) {
      puts("OK");
      return 0;
    }
    puts("ERROR");
    return status;
}
