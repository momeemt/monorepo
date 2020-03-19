#include <bits/stdc++.h>
using namespace std;

int main(){
  int n,ans = 0;
  cin >> n;
  vector<int> money(6);
  money[0] = 500;
  money[1] = 100;
  money[2] = 50;
  money[3] = 10;
  money[4] = 5;
  money[5] = 1;
  n = 1000 - n;

  for (int i = 0; i < 6; i++) {
    while (n >= money[i]) {
      n -= money[i];
      ans++;
    }
  }

  cout << ans << endl;
}
