#include <bits/stdc++.h>
using namespace std;

int main() {
  int n,weight;
  vector<int> v(110);
  vector<int> w(110);
  vector<vector<int>> dp(110, vector<int>(10010));

  cin >> n;
  for (int i = 0; i < n; i++) cin >> v[i] >> w[i];
  cin >> weight;

  // dpテーブルのリセット
  for (int i = 0; i <= weight; i++) dp[0][i] = 0;

  for (int i = 0; i < n; i++) {
    for (int j= 0; j <= weight; j++) {

    }
  }
}
