#include <bits/stdc++.h>
using namespace std;
const long long INF = 1LL << 60;

int main() {
  int n;
  vector<int> h(100010);
  vector<long long> dp(100010);
  cin >> n;
  for (int i = 0; i < n; i++) cin >> h[i];
  for (int i = 0; i < n; i++) dp[i] = INF;
  dp[0] = 0;

  for (int i = 0; i < n; i++) {
    dp[i+1] = min(dp[i+1], dp[i] + abs(h[i]-h[i+1]));
    dp[i+2] = min(dp[i+2], dp[i] + abs(h[i]-h[i+2]));
  }

  cout << dp[n-1] << endl;
}
