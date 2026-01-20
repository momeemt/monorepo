# 回帰における誤差

手持ちのN個のサンプル $(x_1, t_1), (x_2, t_2), \dots, (x_N, t_N)$ について、$x_i$ を与えられたら $t_i$ を返すハッシュ関数は常に二乗誤差が0だが、サンプル以外には対応できないので意味がない。
このようなサンプルに対して過学習したモデルは使えないので、訓練用とテスト用のサンプルに分けて訓練を行う。

## 訓練誤差

- モデル $t = f(\boldsymbol{x})$ を明らかにしたい
- 訓練事例 $X_{tr} = \{(\boldsymbol{x}_i, t_i)\}$ を使って学習させる
- 学習した回帰モデル $\hat{t}_i = \hat{f}(\boldsymbol{x}_i)$
- 訓練事例で得た回帰モデルの、訓練事例における誤答率を**訓練誤差**と呼ぶ

$$
\text{TrainingErr} = \frac{1}{\left| X_{tr} \right|} \sum_{(\boldsymbol{x}_i, t_i) \in X_{tr}} (t_i - \hat{f}(\boldsymbol{x}_i))^2
$$

## 汎化誤差

- データ生成分布 $p(\boldsymbol{x}, t)$
    - 知ることができない
- 真のモデル $t = f(\boldsymbol{x})$
    - こちらも知ることができない
- 学習した回帰モデル $\hat{t}_i = \hat{f}(\boldsymbol{x}_i)$

$$
\text{GeneralizationErr} = \int\int (t-\hat{f}(\boldsymbol{x}))^2 p(\boldsymbol{x}, t) \text{d}\boldsymbol{x}\text{d}t
$$

汎化誤差を使えば回帰モデルの性能を調べることができるが、実際にはこれを計算することはできない。
ただし、汎化モデルの上界を証明するような研究は存在し、学習機の性能保証として使える。

## テスト誤差

- モデル $t = f(\boldsymbol{x})$ を明らかにしたい
- テスト事例 $X_{ts} = \{(\boldsymbol{x}_i, t_i)\}$
- 学習した回帰モデル $\hat{t}_i = \hat{f}(\boldsymbol{x}_i)$
- 訓練事例で学習した回帰モデルの、テスト事例における誤答率を**テスト誤差**と呼ぶ

$$
\text{TestErr} = \frac{1}{\left| X_{ts} \right|} \sum_{(\boldsymbol{x}_i, t_i) \in X_{ts}} (t_i - \hat{f}(\boldsymbol{x}_i))^2
$$

汎化誤差の有限サンプル近似がテスト誤差となる。
これは、標本平均が母平均の有限サンプルにおける近似だからで、サンプル数無限大における標本平均は母平均に一致する。

