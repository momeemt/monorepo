#include <stdio.h>

float fahrToCelsius (float degree) {
  return (5.0 / 9.0) * (degree - 32.0);
}

float celsiusToFahr (float degree) {
  return degree * (9.0 / 5.0) + 32.0;
}

int main () {
  float fahr, celsius;
  int lower, upper, step;

  lower = 0;
  upper = 300;
  step = 20;

  celsius = lower;
  printf("%7s\t%7s\n", "celsius", "fahr");
  printf("----------------\n");
  while (fahr <= upper) {
    fahr = celsiusToFahr(celsius);
    printf("%7.0f\t%7.1f\n", celsius, fahr);
    celsius += step;
  }
}
