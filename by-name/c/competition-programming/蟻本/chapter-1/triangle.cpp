#include <bits/stdc++.h>
using namespace std;

int main() {
  int n;
  cin >> n;
  vector<int> a(n);
  for (int i = 0; i < n; i++) {
    cin >> a[i];
  }

  int answer = 0;
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      if (i == j) continue;
      for (int k = 0; k < n; k++) {
        if ((i == k) || (j == k)) continue;
        vector<int> stick(3);
        stick[0] = a[i];
        stick[1] = a[j];
        stick[2] = a[k];

        sort(stick.begin(), stick.end());
        if (stick[0] + stick[1] <= stick[2]) {
          continue;
        }else {
          answer = max(answer,stick[0] + stick[1] + stick[2]);
        }
      }
    }
  }

  cout << answer << endl;
}
