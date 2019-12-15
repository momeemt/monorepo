#include <bits/stdc++.h>
using namespace std;

int main() {
  int l,n;
  cin >> l >> n;
  vector<int> x(n);
  int minans = 0, maxans = 0;

  for (int i = 0; i < n; i++) {
    cin >> x[i];
  }

  for (int i = 0; i < n; i++) {
    int far1 = min(x[i], abs(10-x[i]));
    int far2 = max(x[i], abs(10-x[i]));
    minans = max(minans, far1);
    maxans = max(maxans, far2);
  }

  cout << minans << maxans << endl;
}
