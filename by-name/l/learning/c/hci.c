#include <unistd.h>
#include <time.h>
#include <sys/time.h>
#include <stdio.h>

double gettimeofday_sec () {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return tv.tv_sec + (double)tv.tv_usec*1e-6;
}

int main (void) {
  double t1, t2;
  sleep(5);
  printf("hit now");
  t1 = gettimeofday_sec();
  getchar();
  t2 = gettimeofday_sec();
  printf("time = %10.30f\n", t2 - t1);
  return 0;
}
