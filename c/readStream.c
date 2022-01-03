#include <stdio.h>

int main () {
  int c;

  while ((c = getchar()) != EOF) {
    if (c == ' ' || c == '\n' || c == '\t') {
      putchar('\n');
    } else {
      putchar(c);
    }
  }
}
