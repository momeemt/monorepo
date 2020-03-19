#include <bits/stdc++.h>
using namespace std;

int counter(int x) {
  if (x == 0) {
    return 0;
  } else {
    return counter(x >> 1) + (x & 1);
  }
}

int main() {
  int n;
  cin >> n;
  int a[20];
  int x[20][20];
  int y[20][20];
  int ans = 0;

  for (int i = 0; i < n; i++) {
    cin >> a[i];
    for (int j = 0; j < a[i]; j++) {
      cin >> x[i][j] >> y[i][j];
    }
  }

  for (int bit = 0; bit < (1<<n); bit++) {
    bool ok = true; //矛盾したらfalse
    for (int i = 0; i < n; i++) {
      if (!(bit & (1 << i))){
        continue;
      }
      for (int j = 0; j < a[i]; j++) {
        if (((bit >> (x[i][j])) & 1) ^ y[i][j]) {
          ok = false;
        }
      }
    }
    if (ok) {
      ans = max(ans, counter(bit));
    }
  }
  cout << ans << endl;
  return 0;
}