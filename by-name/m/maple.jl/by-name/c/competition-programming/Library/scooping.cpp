int res = 0;
int right = 0;
int sum = 0; // 乗算なら1
for (int left = 0; left < n; ++left) {
  while (right < n && sum * V[right] <= k) {
    sum += V[right];
    ++right;
  }
  res = min(res, right- left); //最小区間
  
}