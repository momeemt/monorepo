#include <bits/stdc++.h>
using namespace std;

int main() {
  string s;
  cin >> s;

  vector<int> num(4);
  num[3] = s[0] - '0';
  num[2] = s[1] - '0';
  num[1] = s[2] - '0';
  num[0] = s[3] - '0';
  int ans = num[0];
  vector<string> ope(3);

  for (int bit = 0; bit < (1<<3); bit++) {
    ans = num[0];
    for (int i = 2; i >= 0; i--) {
      if (bit & (1 << i)) {
        ans -= num[i+1];
        ope[2-i] = "-";
      } else {
        ans += num[i+1];
        ope[2-i] = "+";
      }

      if (ans == 7) break;
    }
    cout << "ans: "  << ans << " bit: " << bit << endl;
    cout << "ope1: " << ope[0] << " ope2: " << ope[1] << " ope3: " << ope[2] << endl;
  }

  cout << num[3] << ope[0] << num[2] << ope[1] << num[1] << ope[0] << num[0] << "=7" << endl;
}
