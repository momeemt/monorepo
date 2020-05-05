#pragma gcc optimize("Ofast")
#include <bits/stdc++.h>

using namespace std;
using ll = long long;

#define FOR(i, a, b) for (int i = (a); i < (b); ++i)
#define REP(i, n) FOR(i, 0, n)
#define ALL(V) (V).begin(),(V).end()
#define SORT(V) sort(ALL(V)) //小さい方からソート
#define REV(V) reverse(ALL(V)) //リバース
#define RSORT(V) SORT(V);REV(V) //大きい方からソート
#define NPN(V) next_permutation(ALL(V)) //順列
#define pb(n) push_back(n)
#define endl '\n'
#define Endl '\n'
#define DUMP(x)  cout << #x << " = " << (x) << endl
#define YES(n) cout << ((n) ? "YES" : "NO"  ) << endl
#define Yes(n) cout << ((n) ? "Yes" : "No"  ) << endl
#define Yay(n) cout << ((n) ? "Yay!": ":(") << endl
#define RAPID cin.tie(0);ios::sync_with_stdio(false)
#define IN(n) cin >> n
#define IN2(a,b) cin >> a >> b
#define IN3(a,b,c) cin >> a >> b >> c 
#define VIN(V) for(int i = 0; i < (V).size(); i++) {cin >> (V).at(i);}
#define OUT(n) cout << n << endl
#define VOUT(V) REP(i, (V).size()) {cout << (V)[i] << endl;}
#define VOUT2(V) REP(i, (V).size()) {cout << (V)[i] << " ";} cout<<endl;

// 型マクロ定義
#define int long long
#define P pair<ll,ll>
#define Vi vector<ll>
#define Vd vector<double>
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

int gcd(int a,int b){return b?gcd(b,a%b):a;} //最小公倍数

// デフォルト変数定義
int n,m,a,b,c,x,y,z;
double d,e,f;
string s,t;
//

signed main() {
  RAPID;
  IN(n);
  if(n>=1000) OUT("ABD");
  else OUT("ABC");
}