# 勾配降下法の収束

## μ強凸

ある関数 $f: \R^D\to \R$ が以下を満たすとき、$f$ は**μ強凸**であるという。

$$
f(\boldsymbol{y}) > f(\boldsymbol{x}) + (\boldsymbol{y} - \boldsymbol{x})^T \nabla f(\boldsymbol{x}) + \frac{\mu}{2} |\!| \boldsymbol{x} - \boldsymbol{y} |\!|_2^2
$$

ここで、$\mu$は凸性の強さを表している。

## L平滑

ある関数 $f: \R^D \to \R$ が以下を満たすとき、$f$ は**L平滑**であるという。

$$
|\!| \nabla f(\boldsymbol{x}) - \nabla f(\boldsymbol{y}) |\!|_2 < L |\!| \boldsymbol{x} - \boldsymbol{y} |\!|_2
$$

勾配の変化が入力の変化の変化の定数倍で抑えられる性質を持つ。
近接した点の勾配は互いに近接している。

## 勾配降下法の収束

$\boldsymbol{w}^* = \argmin_{\boldsymbol{w}} E(\boldsymbol{w})$ とする。
また関数 $E$ は微分可能な凸関数とする。
関数 $E$ がL平滑で、ステップサイズが $\eta < \frac{1}{L}$ であるとき、以下が成立する。

$$
E(\boldsymbol{w}^{(t)}) - E(\boldsymbol{w}^*) < \frac{2L |\!| \boldsymbol{w}^{(0)} - \boldsymbol{w}^* |\!|^2_2}{t + 4}
$$

収束速度がステップ数$t$について$\Omicron(\frac{1}{t})$となる。
また、誤差を$\epsilon$以下にするためには、$\Omicron(\frac{1}{\epsilon})$回の更新が必要となる。

## μ強凸な誤差関数に対する勾配降下法の収束

$\boldsymbol{w}^* = \argmin_{\boldsymbol{w}} E(\boldsymbol{w})$ とする。
また関数 $E$ は微分可能な凸関数とする。
関数 $E$ がμ強凸（$μ > 0$）かつL平滑（$L > 0$）で、$\eta = \frac{1}{L}$ であるとき、以下が成立する。

$$
E(\boldsymbol{w}^{(t)}) - E(\boldsymbol{w}^*) < (1 - \frac{\mu}{L})^t [E(\boldsymbol(w)^{(0)} - E(\boldsymbol{w}^*)]
$$

収束速度はステップ数 $t$、収束係数 $c = 1 - \frac{\mu}{L}$ に対して、$\Omicron (c^t)$。
誤差を $\epsilon$ 以下にするには、$\Omicron(\log{(\frac{1}{\epsilon})})$ 回の更新で良い。

つまり、μ強凸である方が収束が高速。
回帰やridge回帰は強凸かつL平滑で、ロジスティック回帰はL平滑だが強凸ではない。
また、LassoやSVMはL平滑ではない。

## 学習率
学習率は小さすぎると収束が遅くなり、大きすぎると収束は早いが最適解周辺で振動する。
また、非常に大きいと発散してしまう。

更新回数が増加するにつれて学習率を小さくしたり、更新量が減少するにつれて学習率を小さくさせるようなスケジューリングができる。
しかし、適切な学習率を理論的に決定することは困難で、問題ごとにチューニングしなければならない。

