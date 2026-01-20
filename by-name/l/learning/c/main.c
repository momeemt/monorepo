#include <stdio.h>

#define LOWER 0
#define UPPER 300
#define STEP 20

float fahrToCelsius (float degree) {
  return (5.0 / 9.0) * (degree - 32.0);
}

float celsiusToFahr (float degree) {
  return degree * (9.0 / 5.0) + 32.0;
}

int main () {
  printf("%5s\t%7s\n", "fahr", "celsius");
  printf("----------------\n");
  for (float fahr = UPPER; fahr >= LOWER; fahr -= STEP) {
    float celsius = fahrToCelsius(fahr);
    printf("%5.0f\t%7.1f\n", fahr, celsius);
  }
}
