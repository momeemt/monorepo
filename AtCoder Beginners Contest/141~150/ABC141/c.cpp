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
int n,k,q;
//

signed main() {
  cin.tie(0);
  ios::sync_with_stdio(false);
  cin >> n >> k >> q;
  vector<int> a(q);
  vector<int> ac(n);
  REP(i, q) {
    cin >> a[i];
    ac[a[i]-1]++; //正解数
  }
  REP(i, n) {
    if(k-q+ac[i] > 0) {
      cout << "Yes" << endl;
    } else { 
      cout << "No" << endl;
    }
  }
}