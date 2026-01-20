#include <iostream>
#include <cstdio>
using namespace std;
typedef long long ll;
ll h, w, ca, cb, ans;
bool v[405][405];
char a[405][405];

void f(ll p, ll q) {
	if(p<1 || q<1 || p>h || q>w || v[p][q]) return;
	v[p][q] = 1;
	if(a[p][q]=='#') ca++; else cb++;
	if(a[p][q] != a[p+1][q]) f(p+1, q);
	if(a[p][q] != a[p-1][q]) f(p-1, q);
	if(a[p][q] != a[p][q+1]) f(p, q+1);
	if(a[p][q] != a[p][q-1]) f(p, q-1);
}

int main() {
	ll i, j;
	cin>>h>>w;
	for(i=1; i<=h; i++) scanf("%s", &a[i][1]);
	for(i=1; i<=h; i++) for(j=1; j<=w; j++) {
		if(!v[i][j]) {
			ca = cb = 0;
			f(i, j);
			ans += ca * cb;
		}
	}
	cout<<ans<<endl;
	return 0;
}
