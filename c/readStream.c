#include <stdio.h>

int main () {
  int c, whitespace, tab, newline;

  whitespace = 0;
  tab = 0;
  newline = 0;
  while ((c = getchar()) != EOF)
    if (c == ' ') {
      ++whitespace;
    } else if (c == '\t') {
      ++tab;
    } else if (c == '\n') {
      ++newline;
    }
  printf("空白: %d\n", whitespace);
  printf("タブ: %d\n", tab);
  printf("改行: %d\n", newline);
}
