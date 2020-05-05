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
#define VSUM(V) accumulate(ALL(V), 0)
#define MID(a,b,c) (a) < (b) && (b) < (c)
#define MIDe(a,b,c) (a) <= (b) && (b) <= (c)
#define IN(n) cin >> n
#define IN2(a,b) cin >> a >> b
#define IN3(a,b,c) cin >> a >> b >> c 
#define IN4(a,b,c,d) cin >> a >> b >> c >> d
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

int gcd(int a,int b){return b != 0 ? gcd(b, a % b) : a;} //最大公約数
int lcm(int a, int b){return a * b / gcd(a, b);}
string toStrUp(string str){char diff = 'A'-'a';REP(i,str.size()) str[i] += diff;return str;}
string gCh(string str, int key){return str.substr(key,1);}

signed main() {
  RAPID;
  // デフォルト変数定義
  int n=0,m=0,a=0,b=0,c=0,d=0,x=0,y=0,z=0;
  string s="",t="";
  //

  // ここから
  IN(n);
  Vs W(n);
  VIN(W)
  bool test1 = true;
  REP(i,n){
    REP(j,n){
      if(i==j) continue;
      if(W[i]==W[j]) test1 = false;
    }
  }
  bool test2 = true;
  REP(i,n-1){
    if(W[i][W[i].size()-1] != W[i+1][0]) test2 = false;
  }
  Yes(test1 && test2);
}