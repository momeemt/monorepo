# 分類

分類問題ではラベルが離散値であり、たとえば気温や湿度から天気（晴れ、曇り、雨）を予測する。

事例 $(x_i, t_i)$（$x_i \in \R^D, t_i \in \{C_1, C_2\}$）から未知事例のラベルを当てる。

空間をクラスごとに分割した領域全体を**決定領域**（decision region）という。
また、異なるクラスの領域を分割している線や面を**決定境界**（decision boundary）という。
決定境界が線形であるとき、線形分類可能、そうでないとき線形分類不可能であるという。

- 決定的識別モデル
    - $t_i \in \{-1, 1\}$
    - 決定境界 $f(\boldsymbol{x})$ を学習する
    - $f(\boldsymbol{x}) > 0$ であるとき、$\boldsymbol{x}$ のラベルは $C_1$
- 確率的識別モデル
    - $t_i \in \{0, 1\}$
    - 条件付き確率 $p(C_1 \mid \boldsymbol{x})$ を学習する
    - $p(C_1 \mid \boldsymbol{x}) > 0.5$ であるとき、$\boldsymbol{x}$ のラベルは $C_1$

ここで、最も単純な決定的識別モデル $t_i$ は超平面 $\boldsymbol{w}^T \boldsymbol{x} = 0$ に用いて以下のように定義できる。

$$
t_i = \text{sgn}(\boldsymbol{w}^T \boldsymbol{x}_i) =
\left\{ \,
    \begin{aligned}
        & 1 \quad \text{if} \quad \boldsymbol{w}^T \boldsymbol{x}_i > 0 \\
        & -1 \quad \text{o.w.} \quad (\boldsymbol{w}^T \boldsymbol{x}_i \le 0)
    \end{aligned}
\right.
$$

回帰では $\boldsymbol{w}^T\boldsymbol{x}$ そのものが予測を与えたが、分類では識別モデルを別に定義することに注意。

## 最適な線形分類モデル

正しい分類と予測した分類の不一致数である**分類誤差**を最小化するような $\boldsymbol{w}$ が最適なモデルである。
したがって、以下のような誤差関数が定義できる。

$$
E(\boldsymbol{w}) = \sum^N_{i=1} I(t_i, \text{sgn}(\boldsymbol{w}^T \boldsymbol{x}_i))
$$

ただし、$I(a, b)$ は$a$と$b$が一致するなら0、不一致なら1を返す関数である。

正しい分類を与える超平面を得るためには、以下の条件を満たす $\boldsymbol{w}$ を求めれば良い。

$$
t_i (\boldsymbol{w}^T \boldsymbol{x}_i) > 0, \quad \forall_i = 1, \dots, N
$$

## サポートベクターマシン（ハードマージン）

先ほどの条件を満たす決定境界は複数存在し得るが、識別平面とデータの距離 = **マージン** が最大である方がより良い適切境界である。
マージンは $\frac{\left| \boldsymbol{w}^T \boldsymbol{x} \right|}{|\!| \boldsymbol{w} |\!|}$ で計算できるから、次の最適化問題を解くことになる。

$$
\max_{\boldsymbol{w}} \min_{i \in \{1, 2, \dots, N\}}
\frac{\left| \boldsymbol{w}^T \boldsymbol{x}_i \right|}{|\!| \boldsymbol{w} |\!|_2}
\quad \text{subject to} \; t_i(\boldsymbol{w}^T \boldsymbol{x}_i) > 0
$$

ここで、超平面は定数倍に対して不変なので、$\min_i t_i(\boldsymbol{w}^T \boldsymbol{x}_i) = 1$ となるようにスケーリングする。
すると、$\min_{i \in \{1, 2, \dots, N\}} \frac{\left| \boldsymbol{w}^T \boldsymbol{x}_i \right|}{|\!| \boldsymbol{w} |\!|_2} = \frac{1}{|\!| \boldsymbol{w} |\!|_2}$ に変形でき、逆数なので双対問題を考えて以下のような最適化問題を考えられる。

$$
\min_{\boldsymbol{w}} |\!| \boldsymbol{w} |\!|^2_2 \quad \text{subject to} \; t_i(\boldsymbol{w}^T x_i) \ge 1, i = 1, \dots, N
$$

これを**ハードマージン**の**サポートベクターマシン**という。

## サポートベクターマシン（ソフトマージン）

ハードマージンのサポートベクターマシンは以下の2つの理由で扱いづらいことがある。

1. 線形等式・不等式制約のある二次形式の最適化である**凸二次計画問題**（QP: quadratic programming）に持ち込めば解けるが、計算としては重い
1. どのような超平面でも正しい分類と予測した分類の不一致数を0にできないような線形分離不可能な場合がある

そこで、予測に失敗した際に識別平面からの距離に応じたペナルティを与えることを考える。

$$
\min_{\boldsymbol{w}} |\!| \boldsymbol{w} |\!|^2_2 + C \sum^N_{i=1} \max \{ 0, 1-t(\boldsymbol{w}^T \boldsymbol{x}_i) \}
$$

これを**ソフトマージン**のサポートベクターマシンという。

## 損失関数への一般化

ソフトマージンのSVMは、L2正則化項と各データに対する個別のペナルティ = 損失関数の足し合わせであると見なすことができる。
回帰で扱う損失関数は二乗損失と呼ぶが、SVMにおける損失を**ヒンジ損失**という。

$$
l_{\text{hinge}} (t_i, \boldsymbol{w}^T \boldsymbol{x}_i) = \max \{0, 1 - t_i(\boldsymbol{w}^T \boldsymbol{x}_i)\}
$$

0-1損失関数は正確に外れたケースに対してだけ一定のペナルティを与えられるが、組合せ最適化により最適化されるため簡単には解けず、マージン最大化も考慮されない。
また、二乗損失は微分可能で解析解を得ることができるが、当たっているのに巨大な損失を与えてしまうので良い分類モデルであるかは疑問。
ヒンジ損失関数は微分可能ではないが凸関数なので劣勾配を考えることができ、確率的劣勾配降下法により大局的最適化を行うことができる。
