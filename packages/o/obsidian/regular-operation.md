---
aliases:
  - 正規演算
tags:
  - 計算理論
  - オートマトン
---
$A, B$ を[[言語]]とする。正規演算とは、以下のように定義された[[和集合演算]]、[[連結演算]]、[[スター演算]]のいずれかである

- 和集合演算
	- $A \cup B = \{ x \mid x \in A \lor x \in B\}$
- 連結演算
	- $A \circ B = \{xy \mid x \in A \land y \in B\}$
- スター演算
	- $A^* = \underset{k \ge 0}{\bigcup} A^k$  
	- ただし、$A^0 = \{\varepsilon\}$、$A^{k+1} = A^k \circ A$ とする
