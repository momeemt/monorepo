#pragma gcc optimize("Ofast")
#include <bits/stdc++.h>
using namespace std;

#define FOR(i, a, b) for (int i = (a); i < (b); ++i)
#define REP(i, n) for (int i = 0; i < (n); ++i)
#define PER(i, n) for (int i = (n-1); i >= 0; --i)
#define ALL(V) (V).begin(),(V).end()
#define SORT(V) sort(ALL(V)) //小さい方からソート
#define REV(V) reverse(ALL(V)) //リバース
#define RSORT(V) SORT(V);REV(V) //大きい方からソート
#define NEXP(V) next_permutation(ALL(V)) //順列
#define pb(n) push_back(n)
#define popb(n) pop_back(n)
#define endl '\n'
#define Endl '\n'
#define DUMP(x)  cout << #x << " = " << (x) << endl
#define YES(n) cout << ((n) ? "YES" : "NO"  ) << endl
#define Yes(n) cout << ((n) ? "Yes" : "No"  ) << endl
#define yes(n) cout << ((n) ? "yes" : "no"  ) << endl
#define Yay(n) cout << ((n) ? "Yay!": ":(") << endl
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
#define VOUT2(V) REP(i, (V).size()) {if((V).size()-1!=i){cout << (V)[i] << " ";}else{cout << (V)[i] << endl;}}

#define int long long
#define P pair<ll,ll>
#define Vi vector<ll>
#define VVi vector<vector<ll>>
#define Vd vector<double>
#define Vb vector<bool>
#define Vs vector<string>
#define Vc vector<char>
#define M map<ll,ll>
#define S set<ll>
#define PQ priority_queue<ll>
#define PQG priority_queue<ll,V,greater<ll>

using ll = long long;
using Graph = vector<vector<int>>;

const int MOD = 1000000007;
const int INF = 1061109567;
const double EPS = 1e-10;
const double PI  = acos(-1.0);
const int dx[4] = {1, 0, -1, 0};
const int dy[4] = {0, 1, 0, -1};

class UnionFind {
public:
  vector <int> par;
  vector <int> siz;

  UnionFind(int sz_): par(sz_), siz(sz_, 1LL) {
    for (int i = 0; i < sz_; ++i) par[i] = i;
  }
  void init(ll sz_) {
    par.resize(sz_);
    siz.assign(sz_, 1LL);
    for (int i = 0; i < sz_; ++i) par[i] = i;
  }

  int root(int x) {
    while (par[x] != x) {
      x = par[x] = par[par[x]];
    }
    return x;
  }

  bool merge(int x, int y) {
    x = root(x);
    y = root(y);
    if (x == y) return false;
    if (siz[x] < siz[y]) swap(x, y);
    siz[x] += siz[y];
    par[y] = x;
    return true;
  }

  bool issame(int x, int y) {
    return root(x) == root(y);
  }

  int size(int x) {
    return siz[root(x)];
  }
};

int gcd(int a, int b) {
  return b != 0 ? gcd(b, a % b) : a;
}

int lcm(int a, int b) {
  return a * b / gcd(a, b);
}

// 文字を全て大文字にします
string toStrUp(string str) {
  char diff = 'A'-'a';
  REP(i,str.size()) str[i] += diff;
  return str;
}

// 文字をstring型で一文字取得します
string get1ch(string str, int key) {
  return str.substr(key,1);
}

// 素因数分解 (O(sqrt(n)))
map<int,int> prime_factor(int n) {
  map<int,int> ret;
  for(int i = 2; i * i <= n; i++) {
    while(n % i == 0) {
      ret[i]++;
      n /= i;
    }
  }
  if(n != 1) ret[n] = 1;
  return ret;
}

// 素数判定 (O(sqrt(n)))
bool is_prime(int x) {
  for(int i = 2; i * i <= x; i++) {
    if(x % i == 0) return false;
  }
  return true;
}

// 進数変換 (O(log n))
template<typename T>
vector<T> convert_base(T x, T b) {
  vector< T > ret;
  T t = 1, k = abs(b);
  while(x) {
    ret.emplace_back((x * t) % k);
    if(ret.back() < 0) ret.back() += k;
    x -= ret.back() * t;
    x /= k;
    t *= b / k;
  }
  if(ret.empty()) ret.emplace_back(0);
  reverse(begin(ret), end(ret));
  return ret;
}

template<class T> inline bool chmin(T& a, T b) {
  if(a > b) {
    a = b;
    return true;
  }
  return false;
}

template<class T> inline bool chmax(T& a, T b) {
  if(a < b){
    a = b;
    return true;
  }
  return false;
}

int modPow(int a, int n) {
  if(n == 1) return a%MOD;
  if(n%2 == 1) return (a*modPow(a,n-1)) % MOD;
  int t = modPow(a, n/2);
  return (t*t) % MOD;
}

signed main() {
  cin.tie(0);
  ios::sync_with_stdio(false);
  cout << fixed << setprecision(15);

  // デフォルト変数定義
  int n=0,m=0,a=0,b=0,c=0,d=0,x=0,y=0,z=0;
  string s="",t="";
  //

  // ここから
  IN2(n,s);
  // 前から2個ずつ
  map<string,int> fr;
  map<string,int> bk;
  REP(i,n){
    if(i==n-1) continue;
    string tmp = s.substr(i,2);
    fr[tmp]++;
  }
  PER(i,n){
    if(i==0) continue;
    string tmp = s.substr(i-1,2);
    bk[tmp]++;
  }
  vector<pair<int,string>> fkw;
  vector<pair<int,string>> bkw;
  RSORT(fkw);
  RSORT(bkw);
  string fkw1;
  string fkw2;
  if(fkw.size()>=2) fkw2 = fkw[1].second;
  if(fkw.size()>=1) fkw1 = fkw[0].second;
  string bkw1;
  string bkw2;
  if(bkw.size()>=2) bkw2 = bkw[1].second;
  if(bkw.size()>=1) bkw1 = bkw[0].second;
  int ans = 0;
  int ans2 = 0;
  REP(i,n){
    if(i==n-1) {
      ans++;
      break;
    } else {
      if(!fkw1.empty() && fkw1 == s.substr(i,2)) i++;
      if(!fkw2.empty() && fkw2 == s.substr(i,2)) i++;
      ans++;
    }
  }
  PER(i,n){
    if(i==0) {
      ans2++;
      break;
    } else {
      if(!bkw1.empty() && bkw1 == s.substr(i-1,2)) i++;
      if(!bkw2.empty() && bkw2 == s.substr(i-1,2)) i++;
      ans2++;
    }
  }
  OUT(max(ans,ans2));
}