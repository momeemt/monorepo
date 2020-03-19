#include <bits/stdc++.h>
using namespace std;

int main() {
  string s;
  int ans = 7;
  cin >> s;
  if (s == "SAT") {
    ans = 1;
  }else if (s == "FRI") {
    ans = 2;
  }else if (s == "THU") {
    ans = 3;
  }else if (s == "WED") {
    ans = 4;
  }else if (s == "TUE") {
    ans = 5;
  }else if (s == "MON") {
    ans = 6;
  }

  cout << ans << endl;
}