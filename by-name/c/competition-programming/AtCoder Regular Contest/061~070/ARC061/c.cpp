#include <bits/stdc++.h>
using namespace std;

int main() {
  string s;
  cin >> s;
  int ans = 0;
  int n = s.length();

  for (int bit = 0; bit < (1<<n); bit++) {
    string save = "";
    for(int i = 0; i < n; i++) {
      if (bit & (1 << i)) {
        ans += stoi(save);
      }else {
        save += s[i];
      }
    }
  }

  cout << ans << endl;
}
