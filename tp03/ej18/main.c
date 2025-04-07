#include <string.h>

int imprime_pantalla(char *encabezado, int tam_enc, char *pie, int tam_pie);

int main(void) {
  char *encabezado = "este es un encabezado";
  int tam_enc = strlen(encabezado);

  char *pie = "este es un pie";
  int tam_pie = strlen(pie);

  imprime_pantalla(encabezado, tam_enc, pie, tam_pie);
  return 0;
}
