#pragma gcc optimize("Ofast")
#include <bits/stdc++.h>

using namespace std;
using ll = long long;

#define FOR(i, a, b) for (int i = (a); i < (b); ++i)
#define REP(i, n) for (int i = 0; i < (n); ++i)
#define SORT(V) sort((V).begin(),(V).end())
#define pb push_back
#define endl '\n'
#define int long long

const int MOD = 1000000007;
const int INF = 1061109567;
const double EPS = 1e-10;
const double PI  = acos(-1.0);

// 変数定義
int n,ans=0;
//

signed main() {
  cin.tie(0);
  ios::sync_with_stdio(false);
  cin >> n;
  vector<int> b(n,MOD);
  REP(i, n-1) {
    cin >> b[i];
  }
  REP(i, n-2) {
    ans += min(b[i], b[i+1]);
  }
  cout << ans + b[0] + b[n-2] << endl;
}