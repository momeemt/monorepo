#include <stdio.h>

int main () {
  int c, whitespace, tab, newline;

  whitespace = 0;
  tab = 0;
  newline = 0;
  while ((c = getchar()) != EOF) {
    if (c == ' ') {
      while (c == ' ') {
        c = getchar();
      }
      putchar(' ');
    }
    putchar(c);
  }
}
