#include <bits/stdc++.h>
using namespace std;

int main() {
  long n;
  long now = 1;
  long des = 0;
  bool disc = false;

  cin >> n;
  vector<long> a(n);
  for (long i = 0; i < n; i++) {
    cin >> a[i];
  }

  for (long i = 0; i < n; i++) {
    if (a[i] == now) {
      disc = true;
      now++;
    } else {
      des++;
    }
  }

  if (disc == false) {
    cout << -1 << endl;
  } else {
    cout << des << endl;
  }
  return 0;
}
