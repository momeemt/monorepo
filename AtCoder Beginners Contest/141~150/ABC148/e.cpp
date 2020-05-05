#include <bits/stdc++.h>
using namespace std;

int main() {
  long long n;
  long long ans = 0;
  long long div = 10;
  cin >> n;

  if (n < 2) {
    cout << 0 << endl;
  } else if (n % 2 == 1) {
    cout << 0 << endl;
  } else {
    while (div <= n) {
      ans += n / div;
      div *= 5;
    }
    cout << ans << endl;
  }
}
