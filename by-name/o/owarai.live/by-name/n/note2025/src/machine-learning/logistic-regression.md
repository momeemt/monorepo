# ロジスティック回帰

## ロジスティックシグモイド関数

$$
\sigma(a) = \frac{1}{1 + \exp{(-a)}}
$$

神経細胞の挙動を模倣した関数で、全ての実数を $[0, 1]$ の範囲に変換できる。
$[-3, 3]$ 付近では線形関数に近い挙動で、絶対値が大きな値に対しては感度が低い。
以下の性質を満たす。

- $\sigma(-a) = 1 - \sigma(a)$
- $\frac{\text{d}}{\text{d}a}\sigma(a) = \sigma(a)(1 - \sigma(a))$

## ロジスティック回帰

$x$ のラベルが $t = 1$ である確率を $x$ の式でモデル化したいが、そのまま線形回帰によってモデル化すると確率の値が無限大に発散してしまう可能性がある。
そこで、確率 $p$ のロジット: $\text{logit}(p) = \log{\frac{p}{1-p}}$ について線形回帰で行う。

$$
\text{logit}(p_{\boldsymbol{x}}) =
\boldsymbol{w}^T \boldsymbol{x} \Leftrightarrow p_{\boldsymbol{x}} = \sigma(\boldsymbol{w}^T \boldsymbol{x})
$$

左の式からは同値変形して目的である確率 $p_\boldsymbol{x}$ を得ることができる。

### 損失

ロジスティック回帰が出力する予測 $\hat{t}_n = \sigma(\boldsymbol{w}^T \boldsymbol{x}_n)$ と実現値 $t_n$ について、予測をベルヌーイ分布と見なすと実現値の尤度を計算できる。

$$
L(\boldsymbol{w}) = \prod^N_{n = 1} \hat{t}_n^{t_n} (1-\hat{t}_n)^{(1 - t_n)}
$$

$L(\boldsymbol{w})$ は、予測が訓練データに対してどの程度尤もらしいかを評価している。
ここで尤度関数を最大化する代わりに、負の対数尤度関数 = **交差エントロピー損失**を最小化することを考えると、損失関数 $E(\boldsymbol{w})$ は以下のように書ける。

$$
E(\boldsymbol{w}) = -\log{L(\boldsymbol{w})} = -\sum^N_{n=1} \{t_n \log{\hat{t}_n} + (1-t_n)\log{(1-\hat{t}_n)}\}
$$

シグモイド関数が含まれるので解析的に勾配を0にする $\boldsymbol{w}$ を求めることはできない。
そこで、最急降下法で最適化する。

