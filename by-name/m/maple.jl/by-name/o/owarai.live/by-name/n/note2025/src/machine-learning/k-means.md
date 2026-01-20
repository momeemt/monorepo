# k-means

データを教師ラベルなしでクラスタ分けする手法を**クラスタリング**という。似ているかどうかは距離や類似度によって計算する。

- ユークリッド距離
    - $d(\boldsymbol{x}, \boldsymbol{y}) = (\boldsymbol{x} - \boldsymbol{y})^T (\boldsymbol{x} - \boldsymbol{y})$
- コサイン類似度
    - $s(\boldsymbol{x}, \boldsymbol{y}) = \frac{\boldsymbol{x}^T \boldsymbol{y}}{\sqrt{(\boldsymbol{x}^T \boldsymbol{x})(\boldsymbol{y}^T \boldsymbol{y})}}$

ユークリッド距離におけるクラスタリングを**k-means**という。
また、クラスタの代表点を**プロトタイプ**という。

- データ: $\{\boldsymbol{x}_1, \dots, \boldsymbol{x}_N\}, \boldsymbol{x}_i \in \R^D$
- プロトタイプ: $\{\boldsymbol{\mu_1}, \dots, \boldsymbol{\mu}_K\}, \boldsymbol{\mu}_j \in \R^D$

割当変数 $r_{ik}$ は次のように定義される。

$$
r_{ik} =
\left\{
    \begin{aligned}
        & 1 \quad \text{if} \quad \boldsymbol{x}_i \; \text{is assigned to} \; \boldsymbol{\mu}_k \\
        & 0 \quad \text{o.w.}
\end{aligned}
\right.
$$

プロトタイプ $\mu_k$ に割り当てられているデータがどのくらい散らばっているかを最小化する = **歪み尺度最小化問題**。

$$
J(\boldsymbol{\mu_1}, \dots, \boldsymbol{\mu_K}, r_{11}, \dots, r_{nk})
= \sum^K_{k=1} \sum^N_{n=1} r_{nk} |\!| \boldsymbol{x}_n - \boldsymbol{\mu}_k |\!|^2_2
$$

これを $J(\boldsymbol{\mu}_k, r_{nk})$ と書くことにすると、k-meansは以下の最適化問題を解くのと同等である。

$$
\argmin_{\boldsymbol{\mu}_k, r_{nk}} J(\mu_k, r_{nk})
$$

