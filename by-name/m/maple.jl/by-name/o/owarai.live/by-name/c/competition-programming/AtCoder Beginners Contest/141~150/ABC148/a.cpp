#include <bits/stdc++.h>
using namespace std;

int main() {
  int a,b;
  cin >> a >> b;
  if (a + b == 4) {
    cout << 2 << endl;
  } else if (a + b == 3) {
    cout << 3 << endl;
  } else {
    cout << 1 << endl;
  }
  return 0;
}
