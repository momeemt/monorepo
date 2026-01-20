#include <bits/stdc++.h>
using namespace std;

int main() {
  vector<int> c(6);
  vector<int> v(6);
  v = [1, 5, 10, 50, 100, 500];

  for (int i = 0; i < 6; i++) {
    cin >> c[i];
  }

  int a;
  int ans = 0;
  cin >> a;

  for (int i = 5; i <= 0; i++) {
    int sum = min(a/v[i], c[i]);
    a -= t * v[i];
    ans += t;
  }

  cout << ans << endl;
}
