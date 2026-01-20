# リッジ回帰

重回帰分析の誤差関数に含まれる二乗誤差項 $E(\boldsymbol{w}) = \sum^N_{i = 1} (t_i - \boldsymbol{w}^T \boldsymbol{x}_i)^2$ に、L2正則化項を加えたものを誤差関数とする回帰を**リッジ回帰**（Ridge regression）という。

$$
E(\boldsymbol{w}) = \sum^N_{i = 1} (t_i - \boldsymbol{w}^T \boldsymbol{x}_i)^2 + \lambda \boldsymbol{w}^T \boldsymbol{w}
$$

L2正則化項では$\boldsymbol{w}$の各要素が大きい値を取ると大きくなるため、複雑さを抑制する。
また、二乗誤差項も凸関数で、L2正則化項も凸関数であるから、誤差関数全体としても凸関数であり、唯一の局所最適解を持つ。
さらに、微分可能であるから解析解も求められる。

