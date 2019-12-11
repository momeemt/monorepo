#include <bits/stdc++.h>
using namespace std;

int main() {
  int n;
  cin >> n;
  int a[20];
  int x[20][20];
  int y[20][20];

  for (int i = 0; i < n; i++) {
    cin >> a[i];
    for (int j = 0; j < a[i]; j++) {
      cin >> x[i][j] >> y[i][j];
    }
  }

  for (int bit = 0; bit < (1<<n); bit++) {
    bool hokotate = true;
    
  }
}