# ラッソ回帰

重回帰分析の誤差関数に含まれる二乗誤差項 $E(\boldsymbol{w}) = \sum^N_{i=1} (t_i - \boldsymbol{w}^T \boldsymbol{x}_i)^2$ に、L1正則化項を加えたものを誤差関数とする回帰を**ラッソ回帰**（Lasso regression）という。

$$
E(\boldsymbol{w}) = \sum^N_{i = 1} (t_i - \boldsymbol{w}^T \boldsymbol{x})^2 + \lambda \sum^D_{i = 1} \left| w_i \right|
$$

原点からの遠さに対して線形で罰する。
誤差項もL1正則化項も凸関数なので最適解は比較的求めやすいが、原点付近で微分不可能なので解析解を求めることはできない。

L1正則化項は目的関数の等高線と正則化項の等高線の接する部分が軸上になりやすく、係数が0になるので結果的に特徴選択もできることがある。

