#include <bits/stdc++.h>
using namespace std;

int main() {
  int n;
  string s,t;
  string ans = "";
  cin >> n >> s >> t;

  for (int i = 0; i < n; i++) {
    ans += s[i];
    ans += t[i];
  }
  cout << ans << endl;
  return 0;
}
