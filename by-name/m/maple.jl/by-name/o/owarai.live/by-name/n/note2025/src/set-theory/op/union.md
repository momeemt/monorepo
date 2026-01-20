# 和集合

```admonish title="{{def}}{def:union}[和集合]"

2つの集合 $A, B$ が与えられたとき、$A$ の元と $B$ の元をすべて集めて得られる集合

$$
A \cup B = \{x \mid x \in A \lor x \in B\}
$$

を $A$ と $B$ の**和集合**という。
```

記号 $\cup$ は**結び**、join、cupなどと呼ばれる。
たとえば、$A$ を正の偶数全体の集合、$B$ を正の奇数全体の集合とすると、$A \cup B = \N$。

## 基本的な性質

### 包含関係

```admonish title="{{prop}}{prop:union_subset}[和集合の包含関係]"
$$
A \sub A \cup B, \quad B \sub A \cup B
$$
```

```admonish tip title="{{fref:prop:union_subset}} の証明" collapsible=true
$x \in A$ とする。
{{fref:def:union}} から、$x \in A \cup B$ を満たす。
$\forall_x (x \in A \to x \in A \cup B)$ が正しいから、{{fref:def:subset}} より、$A \sub A \cup B$ が示された。

同様に、$x \in B$ から $x \in A \cup B$ が従い、$B \sub A \cup B$。$\square$
```

### 上位集合閉包

```admonish title="{{prop}}{prop:union_superset}[和集合の上位集合閉包]"
$$
A \sub C, B \sub C \to A \cup B \sub C
$$
```

```admonish tip title="{{fref:prop:union_superset}} の証明" collapsible=true
$x \in A \cup B$ とする。
{{fref:def:union}} から、$x \in A$ または $x \in B$ が従う。
$x \in A$ のとき、$A \sub C$ から $x \in C$ を満たす。
同様に、$x \in B$ のとき、$x \in C$ を満たす。
$x \in A \cup B \to x \in C$ が正しいから、{{fref:def:subset}} より、$A \sub C, B \sub C \to A \cup B \sub C$ が示された。$\square$
```

{{fref:prop:union_subset}} より、$A \cup B$ は $A$ と $B$ をどちらも含む。
また、{{fref:prop:union_superset}} より、$A$ も $B$ も含む任意の集合は、$A \cup B$ を含む。
したがって、$A \cup B$ は、$A, B$ の両方を含む最小の集合であると言える。

### 冪等律

```admonish title="{{prop}}{prop:union_idempotence}[和集合の冪等律]"
$$
A \cup A = A
$$
```

```admonish tip title="{{fref:prop:union_idempotence}} の証明" collapsible=true
$x \in A \cup A$ とする。
{{fref:def:union}} より、$x \in A$ または $x \in A$ が従う。
よって、$x \in A \cup A \to x \in A$ から、$A \cup A \sub A$。
また、$x \in A \to x \in A \cup A$ から、$A \sub A \cup A$。
したがって、$A \cup A = A$。$\square$
```

### 交換律

```admonish title="{{prop}}{prop:union_commutative}[和集合の交換律]"
$$
A \cup B = B \cup A
$$
```

```admonish tip title="{{fref:prop:union_commutative}} の証明" collapsible=true
$x \in A \cup B$ とする。
{{fref:def:union}}より、$x \in A$ または $x \in B$ が従う。

$x \in A$ のとき、$x \in A \to x \in B \cup A$。

$x \in B$ のとき、$x \in B \to x \in B \cup A$。

よって、$x \in A \cup B \to x \in B \cup A$ であるから、$A \cup B \sub B \cup A$。

同様に、$x \in B \cup A$ とすると、$x \in B \cup A \to x \in A \cup B$ が従う。
よって、$B \cup A \sub A \cup B$。

したがって、$A \cup B = B \cup A$。$\square$
```

### 結合律

```admonish title="{{prop}}{prop:union_associative}[和集合の結合律]"
$$
(A \cup B) \cup C = A \cup (B \cup C)
$$
```

```admonish tip title="{{fref:prop:union_associative}} の証明" collapsible=true
$x \in (A \cup B) \cup C$ とおく。
{{fref:def:union}}より、$x \in A \cup B$ または $x \in C$ が従う。

$x \in A$ または $x \in B$ または $x \in C$

$\to x \in A$ または $x \in (B \cup C)$

$\to x \in A \cup (B \cup C)$

よって、$(A \cup B) \cup C \sub A \cup (B \cup C)$ が示せた。

同様に、$x \in A \cup (B \cup C)$ とおくと、$x \in (A \cup B) \cup C$ が従うから、$(A \cup B) \cup C \supset A \cup (B \cup C)$ が示せた。

したがって、$(A \cup B) \cup C = A \cup (B \cup C)$ が示された。$\square$
```

### 結合律の一般化

```admonish title="{{prop}}{prop:union_associative_general}[和集合の結合律の一般化]"
一般に、$n$ 個の集合 $A_1, A_2, \dots, A_n$ があるとき、$A_1 \cup A_2 \cup \cdots \cup A_n$ という表現のどこにどのような順序で括弧をつけても、結果として得られる集合は同じ
```

自分で書いた証明は証明になっていなかったのでチャッピーに教えてもらった。
仮定を適用できる範囲が自分が思っていたより広かった。

```admonish tip title="{{fref:prop:union_associative_general}} の証明" collapsible=true
任意の括弧の付け方をした式 $E_k = A_1 \cup A_2 \cup \cdots \cup A_k$ は、常に集合 $A_1 \cup \cdots \cup A_k$ に等しいと仮定する。

任意の括弧付き表現 $E_{k+1}$ は $1 \le r \le k$ の下で、必ず $B = A_1 \cup \cdots \cup A_r$ と $C = A_{r+1} \cup \cdots \cup A_{k+1}$ を用いて、次のように表せる。

$$
E_{k + 1} = B \cup C
$$

仮定より、$B = A_1 \cup \cdots \cup A_r$ と $C = A_{r+1} \cup \cdots \cup A_{k+1}$ が成立するから、
{{fref:prop:union_associative}}より、$E_{k+1}$ は括弧の付け方によらず結果は同じ集合となる。

したがって、{{fref:prop:union_associative_general}}は数学的帰納法よりすべての $n$ で成り立つ。$\square$
```

結合律の一般化が成り立つので、括弧を省略して次のように表してよい。

$$
A_1 \cup A_2 \cup \cdots \cup A_n = \bigcup_{i=1}^n A_i
$$

### 包含と和集合の同値命題

```admonish title="{{prop}}{prop:union_absorption}[包含と和集合の同値命題]"
$$
A \sub B \Leftrightarrow A \cup B = B
$$
```

```admonish tip title="{{fref:prop:union_absorption}} の証明" collapsible=true
$A \sub B$ ならば、$A \sub B$ かつ $B \sub B$ であるから、
{{fref:prop:union_superset}}より、$A \cup B \sub B$。
また、{{fref:prop:union_subset}}より、$B \sub A \cup B$。
よって、$A \cup B = B$ が成り立つ。

また、$A \cup B = B$ ならば、{{fref:prop:union_subset}}より、$A \sub A \cup B$ であるから、$A \sub B$。
よって、$A \sub B$ が成り立つ。

したがって、{{fref:prop:union_absorption}}は示された。$\square$
```

### 単調性

```admonish title="{{prop}}{prop:union_monotonicity}[和集合の単調性]"
$$
A \sub B \to A \cup C \sub B \cup C
$$
```

```admonish tip title="{{fref:prop:union_monotonicity}} の証明" collapsible=true
{{fref:prop:union_absorption}}より、$A \sub B \Leftrightarrow A \cup B = B$。
また、$A \cup B = B$ ならば、{{fref:prop:union_subset}}より、$A \sub A \cup B = B$。
{{fref:prop:union_associative}}より、$A \cup C \sub A \cup B \cup C = B \cup C$。

したがって、$A \sub B \to A \cup C \sub B \cup C$ が示された。
```

チャッピーがもっと賢い証明を教えてくれた。
自分が書いた証明は嘘ではないけど冗長っぽい。

```admonish tip title="{{fref:prop:union_monotonicity}} の証明② " collapsible=true
{{fref:prop:union_subset}}から、$C \sub B \cup C$。
また仮定から、$A \sub B \sub B \cup C$。

{{fref:prop:union_superset}}より、$A \cup C \sub B \cup C$ となり、示された。
```

かしこ！全く思いつかなかった。

### 恒等律

```admonish title="{{prop}}{prop:union_identity}[和集合の恒等律]"
$$
\varnothing \cup A = A
$$
```

```admonish tip title="{{fref:prop:union_identity}} の証明" collapsible=true
{{fref:prop:union_associative}}より、示したい命題を $\varnothing \cup \varnothing \cup A = \varnothing \cup A$ に同値変形する。
また、{{fref:prop:union_idempotence}}より、$\varnothing \cup \varnothing = \varnothing$。
よって、示したい命題は $\varnothing \cup A = \varnothing \cup A$ に同値変形できるが、これは自明。

したがって、$\varnothing \cup A = A$ を示せた。
```

教科書を読んでいたら {{fref:prop:union_absorption}}を使っても示せることが書かれていた。
結構感動した。

```admonish tip title="{{fref:prop:union_identity}} の証明② " collapsible=true
任意の集合 $A$ に対して、$\varnothing \sub A$ であるから、
{{fref:prop:union_absorption}}より、$\varnothing \sub A \Leftrightarrow \varnothing \cup A = A$。
よって示された。
```
