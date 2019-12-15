#include <bits/stdc++.h>
using namespace std;

int main() {
  stack<int> s;
  s.push(1);
  s.push(2);
  s.push(3);
  cout << s.top() << endl;
  s.pop();
  cout << s.top() << endl;
  s.pop();
  cout << s.top() << endl;
  s.pop();
}
