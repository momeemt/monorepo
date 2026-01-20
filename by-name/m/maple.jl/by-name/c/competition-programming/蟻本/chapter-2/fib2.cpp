#include <bits/stdc++.h>
using namespace std;
vector<int> memo(100);

int fib(int n) {
  if (n <= 1) return n;
  if (memo[n] != 0) return memo[n];
  return memo[n] = fib(n - 1) + fib(n - 2);
}

int main() {
  cout << fib(45) << endl;
}
