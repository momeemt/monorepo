#pragma gcc optimize("Ofast")
#include <bits/stdc++.h>

using namespace std;
using ll = long long;

#define FOR(i, a, b) for (int i = (a); i < (b); ++i)
#define REP(i, n) for (int i = 0; i < (n); ++i)
#define SORT(V) sort((V).begin(),(V).end())
#define pb(n) push_back(n)
#define endl '\n'
#define Endl '\n'
#define DUMP(x)  cout << #x << " = " << (x) << endl
#define YES(n) cout << ((n) ? "YES" : "NO"  ) << endl
#define Yes(n) cout << ((n) ? "Yes" : "No"  ) << endl
#define RAPID cin.tie(0);ios::sync_with_stdio(false)
#define IN(n) cin >> n
#define IN2(a,b) cin >> a >> b
#define IN3(a,b,c) cin >> a >> b >> c 
#define VIN(V) for(int i = 0; i < (V).size(); i++) {cin >> (V).at(i);}
#define OUT(n) cout << n << endl
#define VOUT(V) for(int i = 0; i < (V).size(); i++) {cout << (V).at(i) << endl;}

// 型マクロ定義
#define int long long
#define P pair<ll,ll>
#define Vi vector<ll>
#define Vs vector<string>
#define Vc vector<char>
#define M map<ll,ll>
#define S set<ll>
#define PQ priority_queue<ll>
#define PQG priority_queue<ll,V,greater<ll>
//

const int MOD = 1000000007;
const int INF = 1061109567;
const double EPS = 1e-10;
const double PI  = acos(-1.0);

// デフォルト変数定義
int n,m,a,b,c=1,x,y,z;
string s,t;
//

signed main() {
  RAPID;
  IN(n);
  Vi p(n);
  Vi q(n);
  VIN(p)
  VIN(q)
  Vi nums;
  FOR(i, 1, n+1) {
    nums.pb(i);
  }
  while(next_permutation(nums.begin(), nums.end())) {
    if(p == nums) {
      a = c;
    }
    if(q == nums) {
      b = c;
    }
    c++;
  }
  OUT(abs(a-b));
}