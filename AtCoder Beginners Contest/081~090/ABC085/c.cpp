#include <bits/stdc++.h>
using namespace std;

int main() {
  int n,y;
  bool is_exist = true;
  int ans1 = -1, ans2 = -1, ans3 = -1;
  vector<int> bill(3);
  bill = {1000, 5000, 10000};
  cin >> n >> y;

  if (bill[0] * n > y || bill[2] * n < y) {
    is_exist = false;
  }

  if (is_exist) {
    for (int i = 0; i <= (y / 10000); i++) {
      for (int j = 0; j <= ((y - 10000 * i) / 5000); j++) {
        int sub_money = y - 10000 * i - 5000 * j;
        int sum = i + j + sub_money / 1000;
        if (sum == n) {
          ans1 = i;
          ans2 = j;
          ans3 = sub_money / 1000;
          break;
        }
      }
    }
  }

  cout << ans1 << " " << ans2 << " " << ans3 << endl;
}
