#include <bits/stdc++.h>
using namespace std;

long gcd(long a, long b){
  if (a < b) {
      a ^= b;
      b ^= a;
      a ^= b;
  }
  return b ? gcd(b, a % b) : a;
}

long lcm(long a, long b) {
  return a * b / gcd(a, b);
}

int main() {
  long a,b;
  cin >> a >> b;
  cout << lcm(a,b) << endl;
  return 0;
}
