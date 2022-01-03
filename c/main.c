#include <stdio.h>

float fahrToCelsius (float degree) {
  return (5.0 / 9.0) * (degree - 32.0);
}

float celsiusToFahr (float degree) {
  return degree * (9.0 / 5.0) + 32.0;
}

int main () {
  int lower, upper, step;

  lower = 0;
  upper = 300;
  step = 20;

  printf("%5s\t%7s\n", "fahr", "celsius");
  printf("----------------\n");
  for (float fahr = upper; fahr >= lower; fahr -= step) {
    float celsius = fahrToCelsius(fahr);
    printf("%5.0f\t%7.1f\n", fahr, celsius);
  }
}
