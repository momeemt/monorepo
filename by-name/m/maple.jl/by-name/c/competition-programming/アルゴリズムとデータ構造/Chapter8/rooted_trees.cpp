#include <iostream>
using namespace std;
#define MAX 100005
#define NIL -1

struct Node {
  int parent, left, right;
};

Node T[MAX];
int n, D[MAX];

int main() {
  int d,v,c,l,r;
  cin >> n;

  for (int i = 0; i < n; i++) {
    // 木の初期化
    T[i].parent = T[i].left = T[i].right = NIL;
  }

  for (int i = 0; i < n; i++) {
    cin >> v >> d; // 節点番号と次数を受け取る
    for (int j = 0; j < d; j++) {
      cin >> c; // 自分が親である子ノードを受け取る
      if (j == 0) {
        T[v].left = c;
      }

    }
  }
}
