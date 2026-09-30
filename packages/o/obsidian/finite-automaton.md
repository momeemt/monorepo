---
aliases:
  - 有限オートマトン
tags:
  - オートマトン
  - 計算理論
---
有限オートマトン（finite automaton）は、5個[[tuple|組]] $(Q, \Sigma, \delta, q_0, F )$ である
ここで、

1. $Q$ は[[状態]]と呼ばれる有限集合
2. $\Sigma$ は[[alphabet|アルファベット]]と呼ばれる有限集合
3. $\delta: Q \times \Sigma \to Q$ は[[遷移関数]]
4. $q_0 \in Q$ は[[開始状態]]
5. $F \subseteq Q$ は[[受理状態]]の[[set|集合]]

とする。