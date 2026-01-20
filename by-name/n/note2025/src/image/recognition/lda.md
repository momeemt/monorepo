# 線形判別法

2クラス以上を対象にして、各クラスをできるだけ識別しやすい部分空間を求める手法。
クラス間変動のクラス内変動に対する比 $F_s$ を最大にする1次元軸 $\boldsymbol{u}$ を求めることが目標。

全体平均 $\tilde{m}$ を用いて、以下のような変換を行う。

- クラス内変動 $\tilde{\boldsymbol{S}}_w = n_1 \tilde{\sigma}_1^2 + \tilde{\sigma}_2^2$
- クラス間変動 $\tilde{\boldsymbol{S}}_B = n_1 (\tilde{m}_1 - \tilde{m})^2 + n_2 (\tilde{m}_2 - \tilde{m})^2$

よって、$F_s$ は以下のように求められる。

$$
\begin{aligned}
F_s &= \frac{\tilde{\boldsymbol{S}}_B}{\tilde{\boldsymbol{S}}_w} \\
    &= \frac{n_1 n_2}{n} \cdot \frac{(\tilde{m_1} - \tilde{m_2})^2}{n_1 \tilde{\sigma_1}^2 + n_2 \tilde{\sigma}_2^2}
\end{aligned}
$$

クラス間変動を行列として考えると、$i$ クラスのデータ数 $n_i$、全データの平均ベクトル $\boldsymbol{m}$、クラス$i$の平均ベクトル $\boldsymbol{m}_i$ を用いて、次のように定義できる。

$$
\boldsymbol{S}_B = \sum_{i=1,2} n_i (\boldsymbol{m}_i - \boldsymbol{m})(\boldsymbol{m}_i - \boldsymbol{m})^T
$$

同様にクラス内変動行列についても、クラス $i$ の $j$ 番目のデータ $x^i_j$、クラス $i$ の平均ベクトル $\boldsymbol{m}_i$、$i$ クラスのデータ数 $n_i$ を用いて、次のように定義できる。

$$
\begin{aligned}
\boldsymbol{S}_w &= S_{w1} + S_{w2} \\
&= \sum_{i=1}^{n_1} (x_i^1 - \boldsymbol{m}_1)(x_i^1 - \boldsymbol{m}_1)^T + \sum_{i=1}^{n_2} (x_i^2 - \boldsymbol{m}_2)(x_i^2 - \boldsymbol{m}_2)^T
\end{aligned}
$$
