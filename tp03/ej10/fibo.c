#include <stdio.h>
#include <stdlib.h>

int fibo(int n);


int main(int argc, char *argv[]){
  if (argc != 2) {
    printf("Usage: %s <n>\n", argv[0]);
    return 1;
  }

  if (atoi(argv[1]) < 0) {
    printf("Usage: %s <n>\n", argv[0]);
    return 1;
  }

  int n = atoi(argv[1]);
  printf("fibo(%d) = %d\n", n, fibo(n));
  return 0;

}

int fibo(int n){
	if(n<2){
		return 1;
	}
	return fibo(n-1)+fibo(n-2);
}
