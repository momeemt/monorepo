# マハラノビス距離

## 1次元

平均 $\mu$、分散 $\sigma^2$ を用いて、マハラノビス距離 $d$ は次のように定義される。

$$
d = \sqrt{\frac{(\hat{x} - \mu)^2}{\sigma^2}}
$$

## 多次元

平均ベクトル $\boldsymbol{\mu}$、分散共分散行列 $C$ を用いて、$k$ 次元正規分布を $\mathcal{N}(\boldsymbol{\mu}, C)$ とする。
マハラノビス距離 $d$ は次のように定義される。

$$
d = \sqrt{(\boldsymbol{x} - \boldsymbol{\mu})^T C^{-1} (\boldsymbol{x} - \boldsymbol{\mu})}
$$

ただし、$k \quad ( < d)$ 本の $d$ 次元ベクトル $\boldsymbol{X}_i$ の分散共分散行列 $C = \sum^k_{i=1} (X_i - \mu)(X_i - \mu)^T$ は逆行列を持たない。
そこで、行列 $C$ の $k$ 個の固有値 $\lambda_i \quad (> 0)$ と、対応する固有ベクトル $\boldsymbol{u}_i$ を用いて、近似的に擬似逆行列 $C^{-1}$ を定義する。

$$
C^{-1} = \sum^k_{i = 1} \frac{\boldsymbol{u}_i \boldsymbol{u}_i^T}{\lambda_i}
$$
