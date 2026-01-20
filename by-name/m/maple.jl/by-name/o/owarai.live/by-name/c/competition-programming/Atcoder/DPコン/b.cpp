#include <bits/stdc++.h>
using namespace std;
const long long INF = 1LL << 60;

int main() {
  int n,k;
  vector<long long> h(101000);
  vector<long long> dp(101000);

  cin >> n >> k;
  for(int i = 0; i < n; i++) cin >> h[i];
  for(int i = 0; i < n; i++) dp[i] = INF;
  dp[0] = 0;

  for (int i = 0; i < n; i++) {
    for (int j = 1; j <= k; j++) {
      dp[i+j] = min(dp[i+j], dp[i] + abs(h[i]-h[i+j]));
    }
  }

  cout << dp[n-1] << endl;
}
