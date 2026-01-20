# 共通部分

```admonish title="{{def}}{def:intersection}[共通部分]"
2つの集合 $A, B$ があるとき、$A, B$ の両方に共通な元全体の集合

$$
A \cap B = \{ x \mid x \in A, x \in B \}
$$

を $A$ と $B$ の**共通部分**という。
```

記号 $\cap$ は**交わり**、meet、capなどと呼ばれる。
たとえば、$A$ を正の偶数全体の集合、$B$ を正の奇数全体の集合とすると、$A \cap B = \varnothing$。

一般に、$A \cap B \neq \varnothing$ である時には、$A, B$ は**交わる**という。
また、$A \cap B = \varnothing$ である時には、$A, B$ は**交わらない**、または**互いに素である**という。

## 基本的な性質

### 包含関係

```admonish title="{{prop}}{prop:intersection_subset}[共通部分の包含関係]"
$$
A \supset A \cap B, \quad B \supset A \cap B
$$
```

```admonish tip title="{{fref:prop:intersection_subset}} の証明" collapsible=true
任意に $x \in A \cap B$ を取る。
{{fref:def:intersection}}より、$x \in A$ かつ $x \in B$。

よって、$x \in A$ より、$A \supset A \cap B$
また、$x \in B$ より、$B \supset A \cap B$。$\square$
```

### 上位集合閉包

```admonish title="{{prop}}{prop:intersection_superset}[共通部分の上位集合閉包]"
$$
A \sub C, \; B \sub C \to A \cap B \sub C
$$
```

```admonish tip title="{{fref:prop:intersection_superset}} の証明" collapsible=true
任意に $x \in A \cap B$ を取る。
{{fref:def:intersection}}より、$x \in A$ かつ $x \in B$。
また、前提より $A \sub C$ から、$x \in C$。
したがって、$A \sub C, \; B \sub C \to A \cap B \sub C$ が示された。
```

ここから、$A \cap B$ は、$A, B$ の両方に含まれる集合のうちで最大のものであることが言える。

### 冪等律

```admonish title="{{prop}}{prop:intersection_idempotence}[共通部分の冪等律]"
$$
A \cap A = A
$$
```

```admonish tip title="{{fref:prop:intersection_idempotence}} の証明" collapsible=true
任意に $x \in A \cap A$ を取る。
{{fref:def:intersection}}より、$x \in A$ かつ $x \in A$、すなわち$x \in A$。
よって $\forall_x (x \in A \land x \in A \to x \in A)$ を満たすから、$A \cap A \sub A$ が示された。

次に、任意に $x \in A$ を取る。
$A \cap A \supset A$ を示すために、$\forall_x (x \in A \to x \in A \land x \in A)$ を示したい。
ここで、$x \in A \land x \in A$ は $x \in A$ であるから、自明に示される。

したがって、{{fref:prop:intersection_idempotence}}は示された。
```

### 交換律

```admonish title="{{prop}}{prop:intersection_commutative}[共通部分の交換律]"
$$
A \cap B = B \cap A
$$
```

```admonish tip title="{{fref:prop:intersection_commutative}} の証明" collapsible=true
任意に $x \in A \cap B$ をとる。
{{fref:def:intersection}}より、$x \in A$ かつ $x \in B$。
$\forall_x (x \in A \land x \in B \to x \in B \land x \in A)$ を満たすなら $A \cap B \sub B \cap A$ だが、これは自明。

同様に、任意に $x \in B \cap A$ をとる。
{{fref:def:intersection}}より、$x \in B$ かつ $x \in A$。
$\forall_x (x \in B \land x \in A \to x \in A \land x \in B)$ を満たすなら $B \cap A \sub A \cap B$ だが、これも自明。

したがって、$A \cap B = B \cap A$ は示された。
```

### 結合律

```admonish title="{{prop}}{prop:intersection_associative}[共通部分の結合律]"
$$
(A \cap B) \cap C = A \cap (B \cap C)
$$
```

```admonish tip title="{{fref:prop:intersection_associative}} の証明" collapsible=true
任意に $x \in (A \cap B) \cap C$ をとる。
{{fref:def:intersection}}より、以下のように変形できる。

$$
\begin{aligned}
x \in (A \cap B) \cap C &\to x \in A \cap B \land x \in C \\
                        &\to x \in A \land x \in B \land x \in C \\
                        &\to x \in A \land x \in B \cap C
\end{aligned}
$$

よって、$\forall_x (x \in A \cap B \land x \in C \to x \in A \land x \in B \cap C)$ を満たすから、
$(A \cap B) \cap C \sub A \cap (B \cap C)$ が正しい。

同様に、任意に $x \in A \cap (B \cap C)$ を取ると、$x \in A \cap B \land x \in C$ に変形できる。
よって、$\forall_x (x \in A \land x \in B \cap C \to x \in A \cap B \land x \in C)$ を満たすから、
$A \cap (B \cap C) \sub (A \cap B) \cap C$ が正しい。

したがって、$(A \cap B) \cap C = A \cap (B \cap C)$ が示された。
```

{{fref:prop:union_associative_general}}の証明と同様に、共通部分のどこにどのような順序で括弧をつけても結果的に得られる集合は変わらない。
したがって、以下のように書ける。

$$
A_1 \cap A_2 \cap \cdots \cap A_n = \bigcap^n_{i=1} A_i
$$

### 包含と共通集合の同値命題

```admonish title="{{prop}}{prop:intersection_absorption}[包含と共通集合の同値命題]"
$$
A \sub B \Leftrightarrow A \cap B = A
$$
```

```admonish tip title="{{fref:prop:intersection_absorption}} の証明" collapsible=true

```
