#include <bits/stdc++.h>
using namespace std;
 
int main() {
  long a,b,x;
  cin >> a >> b >> x;
  long left = 0;
  long right = 1000000001;
  long search = 0;
  long dn = 0;
  long price = 0;
  for (int i = 0; i < 50; i++) {
    search = round((right + left) / 2);
    long dn = to_string(search).length();
    long price = a * search + b * dn;

    if (price == x) {
      break;
    }else if (price > x) {
      // 高すぎて買えない
      right = search;
      continue;
    }else if (price < x) {
      left = search;
      continue;
    }
  }

  while (a * search + b * (to_string(search).length()) > x) {
    search--;
  }
  
  cout << search << endl;
}