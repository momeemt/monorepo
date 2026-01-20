# Softmax回帰

多クラス分類を行う際に利用する回帰。

## Softmax関数

Sigmoid関数を多ラベルに拡張した関数を**Softmax関数**という。
Softmax関数の $j$ 番目の出力は以下のようになる。

$$
\sigma (\boldsymbol{z})_j = \frac{\exp{(z_j)}}{\sum_d \exp{(z_d)}}
$$

全ての成分が0以上で、和が1になるK次元ベクトル全体の集合を**K-1シンプレクス**という。
K-1シンプレクス上の任意の点は、K次元確率ベクトルである。

$$
\sum_k \sigma (\boldsymbol{z})_k = 1
$$

Softmax関数は $\R^D$ をK-1シンプレクスに写像する。

## Softmax回帰

1-of-k表記（1 hot vector）の訓練データを用いて、以下の予測 $\hat{t}_{nk}$ を計算する。

$$
\hat{t}_{nk} = \text{Pr}(k \mid \boldsymbol{x}_n) = \frac{\exp{(\boldsymbol{w}_k^T \boldsymbol{x}_n)}}{\sum^K_{k=1} \exp{(\boldsymbol{w}_k^T \boldsymbol{x}_n)}}
$$

次に、訓練データ集合全体に対する尤度 $L(\boldsymbol{w})$ を計算する。

$$
L(\boldsymbol{w}) =
\prod^N_{n=1} \prod^K_{k=1} Pr(k \mid \boldsymbol{x}_n)^{t_{n, k}} =
\prod^N_{n=1} \prod^K_{k=1} (\hat{t}_{n, k})^{t_{n, k}}
$$

最後に、誤差関数（交差エントロピー）を得る。

$$
E(\boldsymbol{w}) = -\log{L(\boldsymbol{w})} = -\sum^N_{n=1} \sum^K_{k=1} t_{nk} \log{\hat{t}_{nk}}
$$


