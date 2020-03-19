#include <bits/stdc++.h>
using namespace std;

int main() {
  string s;
  int size,count=0;
  cin >> s;
  size = s.length();

  for (int i = 0; i < size/2; i++) {
    if (s[i] != s[size-i-1]) {
      count++;
    }
  }

  cout << count << endl;
}