#include <bits/stdc++.h>
using namespace std;

#define int long long // 禁忌
using ll = long long;
using lld = long double;
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

// 重み付き辺
template<typename T>
struct edge {
  int src, to;
  T cost;
  
  edge(int to, T cost) : src(-1), to(to), cost(cost) {}

  edge(int src, int to, T cost) : src(src), to(to), cost(cost) {}

  edge &operator=(const int &x) {
    to = x;
    return *this;
  }

  operator int() const { return to; }
};

// 重み付き辺集合
template<typename T>
using Edges = vector<edge<T>>;

// 重み付きグラフ
template<typename T>
using WeightedGraph = vector<Edges<T>>;

using UnWeightedGraph = VVi; // 重みなしグラフ

// 距離行列
template<typename T>
using Matrix = vector<vector<T>>;

const int MOD = 1000000007;
const int INF = 1061109567;
const double EPS = 1e-10;
const double PI  = acos(-1.0);
const int dx[4] = {1, 0, -1, 0};
const int dy[4] = {0, 1, 0, -1};

#define FOR(i, a, b) for (int i = (a); i < (b); ++i)
#define REP(i, n) for (int i = 0; i < (n); ++i)
#define PER(i, n) for (int i = (n-1); i >= 0; --i)
#define ALL(V) (V).begin(),(V).end()
#define SORT(V) sort(ALL(V)) //小さい方からソート
#define REV(V) reverse(ALL(V)) //リバース
#define RSORT(V) SORT(V);REV(V) //大きい方からソート
#define NEXP(V) next_permutation(ALL(V)) //順列
#define pb(n) push_back(n)
#define eb(n) emplace_back(n)
#define popb pop_back()
#define endl '\n'
#define Endl '\n'
#define DUMP(x)  cout << #x << " = " << (x) << endl

// UnionFind
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

// modint
template< int mod >
struct ModInt {
  int x;

  ModInt() : x(0) {}

  ModInt(int64_t y) : x(y >= 0 ? y % mod : (mod - (-y) % mod) % mod) {}

  ModInt &operator+=(const ModInt &p) {
    if((x += p.x) >= mod) x -= mod;
    return *this;
  }

  ModInt &operator-=(const ModInt &p) {
    if((x += mod - p.x) >= mod) x -= mod;
    return *this;
  }

  ModInt &operator*=(const ModInt &p) {
    x = (int) (1LL * x * p.x % mod);
    return *this;
  }

  ModInt &operator/=(const ModInt &p) {
    *this *= p.inverse();
    return *this;
  }

  ModInt operator-() const { return ModInt(-x); }

  ModInt operator+(const ModInt &p) const { return ModInt(*this) += p; }

  ModInt operator-(const ModInt &p) const { return ModInt(*this) -= p; }

  ModInt operator*(const ModInt &p) const { return ModInt(*this) *= p; }

  ModInt operator/(const ModInt &p) const { return ModInt(*this) /= p; }

  bool operator==(const ModInt &p) const { return x == p.x; }

  bool operator!=(const ModInt &p) const { return x != p.x; }

  ModInt inverse() const {
    int a = x, b = mod, u = 1, v = 0, t;
    while(b > 0) {
      t = a / b;
      swap(a -= t * b, b);
      swap(u -= t * v, v);
    }
    return ModInt(u);
  }

  ModInt pow(int64_t n) const {
    ModInt ret(1), mul(x);
    while(n > 0) {
      if(n & 1) ret *= mul;
      mul *= mul;
      n >>= 1;
    }
    return ret;
  }

  friend ostream &operator<<(ostream &os, const ModInt &p) {
    return os << p.x;
  }

  friend istream &operator>>(istream &is, ModInt &a) {
    int64_t t;
    is >> t;
    a = ModInt< mod >(t);
    return (is);
  }

  static int get_mod() { return mod; }
};
using modint = ModInt< MOD >;

// dijkstra O(E logV)
template<typename T>
vector<T> dijkstra(WeightedGraph<T> &g, int s) {
  const auto INF2 = numeric_limits<T>::max();
  vector<T> dist(g.size(), INF2);
  using Pi = pair<T, int>;
  priority_queue<Pi, vector<Pi>, greater<Pi>> que;
  dist[s] = 0;
  que.emplace(dist[s], s);
  while(!que.empty()) {
    T cost;
    int idx;
    tie(cost, idx) = que.top();
    que.pop();
    if(dist[idx] < cost) continue;
    for(auto &e : g[idx]) {
      auto next_cost = cost + e.cost;
      if(dist[e.to] <= next_cost) continue;
      dist[e.to] = next_cost;
      que.emplace(dist[e.to], e.to);
    }
  }
  return dist;
}

// 負の辺を持つ単一始点最短路 O(VE)
template<typename T>
vector<T> bellman_ford(Edges<T> &edges, int V, int s) {
  const auto INF2 = numeric_limits<T>::max();
  vector<T> dist(V, INF2);
  dist[s] = 0;
  REP(i,(V-1)) {
    for(auto &e : edges) {
      if(dist[e.src] == INF2) continue;
      dist[e.to] = min(dist[e.to], dist[e.src] + e.cost);
    }
  }
  for(auto &e : edges) {
    if(dist[e.src] == INF2) continue;
    if(dist[e.src] + e.cost < dist[e.to]) return vector<T>();
  }
  return dist;
}

// 全点対間最短路 O(V^3)
template<typename T>
void warshall_floyd(Matrix<T> &g, T lINF) {
  ll n = g.size();
  REP(k,n){
    REP(i,n){
      REP(j,n){
        if(g[i][k] == lINF || g[k][j] == lINF) continue;
        g[i][j] = min(g[i][j], g[i][k] + g[k][j]);
      }
    }
  }
  return;
}

// 入出力高速化
void fast(void) {
  cin.tie(0);
  ios::sync_with_stdio(false);
  cout << fixed << setprecision(15);
  return;
}

// vectorの合計値を返します
ll vsum(Vi V) {
  ll res = 0LL;
  ll size = V.size();
  REP(i,size) {
    res += V.at(i);
  }
  return res;
}

// vectorの平均値を返します
lld vave(Vi V) {
  lld size = V.size();
  return (lld)vsum(V) / size;
}

// vectorの最大値を返します
ll vmax(Vi V) {
  RSORT(V);
  return V.at(0);
}

// vectorの最小値を返します
ll vmin(Vi V) {
  SORT(V);
  return V.at(0);
}

// 数値 b が a より大きく、 c より小さいことを判定します
template<typename T>
bool mid1(T a, T b, T c) {
  return (a < b) && (b < c);
}

// 数値 b が a以上 で、c以下 であることを判定します
template<typename T>
bool mid2(T a, T b, T c) {
  return (a <= b) && (b <= c);
}

// YES or NO
template<typename T>
void YES(T n) {
  cout << ((n) ? "YES" : "NO" ) << endl;
}

// Yes or No
template<typename T>
void Yes(T n) {
  cout << ((n) ? "Yes" : "No" ) << endl;
}

// yes or no
template<typename T>
void yes(T n) {
  cout << ((n) ? "yes" : "no" ) << endl;
}

// Yay! or :(
template<typename T>
void Yay(T n) {
  cout << ((n) ? "Yay!": ":(") << endl;
}

// 標準入力します
inline void in(void){
  return;
}
template<typename First, typename... Rest>
void in(First& first, Rest&... rest) {
  cin >> first;
  in(rest...);
  return;
}

// vectorを標準入力
template<typename T>
void vin(T& V) {
  ll size = V.size();
  REP(i,size) {
    cin >> V[i];
  }
  return;
}

// 標準出力します
inline void out(void){
  cout << endl;
  return;
}
template<typename T>
void out(T only) {
  cout << only << endl;
  return;
}
template<typename First, typename... Rest>
void out(First first, Rest... rest) {
  cout << first << " ";
  out(rest...);
  return;
}

// vectorを標準出力
template<typename T>
void vout(T& V) {
  ll size = V.size();
  REP(i,size) {
    cout << V.at(i) << endl;
  }
}

// vectorを１行に標準出力
template<typename T>
void vout2(T& V) {
  ll size = V.size();
  REP(i,size) {
    cout << V[i] << " \n"[i==(size-1)];
  }
}

// 最大公約数を求めます
int gcd(int a, int b) {
  return b != 0 ? gcd(b, a % b) : a;
}

// 最小公倍数を求めます
int lcm(int a, int b) {
  return a * b / gcd(a, b);
}

// 文字を全て大文字にします
string toStrUp(string str) {
  char diff = 'A'-'a';
  REP(i,str.size()) str[i] += diff;
  return str;
}

// 素因数分解します (O(sqrt(n)))
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

template<class T>
inline bool chmin(T& a, T b) {
  if(a > b) {
    a = b;
    return true;
  }
  return false;
}

template<class T>
inline bool chmax(T& a, T b) {
  if(a < b){
    a = b;
    return true;
  }
  return false;
}

signed main() {
  fast();
  // 使えない変数名
  // P, M, S, PQ, PQG
  // ここから
  int x,y,k;
  in(x,y,k);
  if(y >= k) {
    out(x + k);
  } else {
    out(x + y - (k-y));
  }
}
