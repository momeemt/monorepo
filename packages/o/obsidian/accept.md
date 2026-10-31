---
aliases:
  - 受理する
tags:
  - オートマトン
  - 計算理論
---
$M = (Q, \Sigma, \delta, q_0, F)$ を[[finite-automaton|有限オートマトン]]とし、$w = w_1 w_2 \cdots w_n$ は[[string|文字列]]で、各$w_i$ は[[alphabet|アルファベット]] $\Sigma$ の[[element|要素]]とする
以下の3つの条件を満たす状態の列 $r_0, r_1, \dots, r_n$ が存在するならば、$M$ は $w$ を **受理する** という

1. $r_0 = q_0$
2. $i = 0, \dots, n-1$ のとき、$\delta(r_i, w_{i+1}) = r_{i+1}$
3. $r_n \in F$