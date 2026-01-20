# 画像認識

- $K \times K$ 画素画像は、$K^2$次元実数ベクトルと見なすことができる
- 3次元実数ベクトル空間 $V$ について、$V$ を張る基底は無限個存在するが、3本の基本ベクトルが最もシンプルな基底
    - $\R^3 = \langle \boldsymbol{e}_1, \boldsymbol{e}_2, \boldsymbol{e}_3 \rangle$
- $G$ が1次独立な画像ベクトル $\boldsymbol{v}_1, \boldsymbol{v}_2, \boldsymbol{v}_3$ で生成されるとき、$\boldsymbol{v}_1, \boldsymbol{v}_2, \boldsymbol{v}_3$ が**基底ベクトル**である
    - 3つのベクトルが同一平面上に存在しない

## 正射影

任意の $v\in V$ は、$v = u + w \quad (u \in U, w \in U^\bot)$ と一意に表される。
このとき、$v$ に対して $u$ を対応させる写像を $V$ から $U$ への**正射影**であるといい、$pr_u$ と書く。

また、$V$ を計量ベクトル空間、$U$ を $V$ の部分空間とする。
$u_1, u_2, \dots, u_k$ を $U$ の正規直交基底とすると、正射影は以下のように書ける。

$$
pr_u = (v, u_1)u_1 + (v, u_2)u_2 + \cdots + (v, u_k) u_k
$$

画像ベクトル空間における正射影は、特徴抽出として極めて重要。
たとえば、$v$ の1次元部分空間 $\langle \boldsymbol{e}_1 \rangle$ への正射影は、ベクトル $\boldsymbol{v}$ から画像成分 $\boldsymbol{e}_1$ のみを抽出することになる。
また、係数 $a_1$ がその成分の強さを意味する。

### 射影行列

射影行列 $\boldsymbol{P}$（$\boldsymbol{P} \in \R^{d \times d}$）は、ベクトル $\boldsymbol{x}$ を$n$次元部分空間 $U = \langle e_1, e_2, \cdots, e_n \rangle$ への正射影ベクトル $\boldsymbol{x'}$ に写像する。

$$
\begin{aligned}
\boldsymbol{x'} &= \boldsymbol{Px} \\
                &= \sum^n_{i=1} \boldsymbol{e}_i \boldsymbol{e}_i^T
\end{aligned}
$$

部分空間 $U$ への射影行列を $\boldsymbol{P}$ とするとき、$U$ の直交補空間 $U^\bot$ への正射影を表す射影行列 $\boldsymbol{Q}$ は以下のようになる。
ただし、行列 $\boldsymbol{I}$ は、射影行列 $\boldsymbol{P}$ と同じサイズの単位行列。

$$
\begin{aligned}
    \boldsymbol{Q} &= \boldsymbol{I} - \boldsymbol{P} \\
    \boldsymbol{x}' &= \boldsymbol{Q} \boldsymbol{x}
\end{aligned}
$$

## 画像パターン分布の局在性

ある同種の物体の画像パターンは相関を持つので、他次元ベクトル空間の部分空間内に集中している。
このような部分空間を、その物体の**固有空間**と呼ぶ。

重みが大きい基底ベクトルを**主成分ベクトル**と呼ぶ。

### 固有空間の求め方

- 主成分分析（PCA）
    - 多変量解析
    - カール・ピアソンが1901年に提案
- KL変換
    - 信号処理
    - Karhunent(1947)、Loeve(1977)

どちらも同値の操作であるが、異なる分野で独立に開発された。

### 主成分

以下のいずれかの基準で主成分を決める。

- 平均二乗誤差最小基準
- 分散最大基準

#### 平均二乗誤差最小基準

$n$ 個の画像ベクトルが与えられている。
そのうち、ある画像 $i$ のベクトルが $\boldsymbol{x}_i$ とする。
また、ベクトル $\boldsymbol{u}_1$ への正射影ベクトルを $\tilde{\boldsymbol{x}}_i$ とする。
このとき、平均二乗誤差は以下の $\epsilon^2 (\boldsymbol{u}_1)$ によって与えられる。

$$
\epsilon^2 (\boldsymbol{u}_1) = \frac{1}{n} \sum^n_{i=1} |\!| \boldsymbol{x}_i - \tilde{\boldsymbol{x}}_i |\!|^2
$$

また、第一主成分のベクトルを求めることは、すなわち最適化問題 $\argmin_{\boldsymbol{u}_1} \epsilon^2 (\boldsymbol{u}_1)$ を解くことである。

さらに、平均二乗誤差最小基準は射影最大基準に同値変形することができる。
これは、二乗誤差 $|\!| \boldsymbol{x}_i - \tilde{\boldsymbol{x}}_i |\!|^2$ と射影長の二乗 $\delta^2(\tilde{\boldsymbol{u}}_1) = |\!| \tilde{\boldsymbol{x}}_i |\!|^2$ の和は三平方の定理から常に定数（$|\!| \boldsymbol{x}_i |\!|^2$）であり、平均二乗誤差が最小を取るとき、常に射影は最大になるからである。

第一主成分のベクトルを求めることは、すなわち最適化問題 $\argmax_{\boldsymbol{u}_1} \delta^2 (\boldsymbol{u}_1)$ を解くことでもある。

平均二乗誤差最小基準では固有値分解により主成分を計算することができる。

1. 主成分を求めたいデータセットから、**自己相関行列** $R = \frac{1}{n} \sum^n_{i=1} \boldsymbol{x}_i \boldsymbol{x}^T_i$ を求める
1. 自己相関行列は、画像ベクトルを列として並べた行列 $A = \begin{bmatrix} \boldsymbol{x}_1 & \boldsymbol{x}_2 & \cdots & \boldsymbol{x}_n \end{bmatrix}$ を用いて、$R = \frac{1}{n} AA^T$ と書ける
1. 自己相関行列 $R$ の固有値と固有ベクトルを求める
1. $k$ 番目に大きい固有値 $\lambda_k$ に対応する固有ベクトル $\boldsymbol{u}_k$ を第$k$主成分ベクトルとする
1. $k$ 番目までのベクトルをとった場合の平均二乗誤差は、$\frac{1}{n} \sum^n_{i=1} \boldsymbol{X}^T_i \boldsymbol{X}_i - \sum^k_{i=1} \lambda_i$ で計算できる
1. 主成分ベクトルをいくつ求めるかは、固有値から求められる**累積寄与率**（集中度）によって決定する。寄与率 $c$ は以下で与えられる

$$
c = \frac{\sum^k_{i=1} \lambda_i}{\sum^N_{i=1}\lambda_i}
$$

#### 分散最大基準

1. 主成分を求めたいデータセットから、**共分散行列** $C$ を求める
1. $C$ の固有値と固有ベクトルを求める
1. $k$ 番目に大きい固有値 $\lambda_k$ に対応する固有ベクトル $\boldsymbol{u}_k$ を第 $k$ 主成分ベクトルとする
1. ここで、固有値 $\lambda_k$ がその方向の**分散**に相当する
1. 主成分ベクトルをいくつ求めるかは、固有値から求められる累積寄与率（集中度）により決定する

共分散行列は、平均ベクトル $\boldsymbol{m}$ を求め、$C = \frac{1}{n} \sum^n_{i=1} (\boldsymbol{x}_i - \boldsymbol{m})(\boldsymbol{x}_i - \boldsymbol{m})^T$ で求められる。

### Sparse PCA

[ALOI: Amsterdam Library of Object Images](https://aloi.science.uva.nl/)に対する主成分分析の結果を観察すると、第一主成分に正規分布が、第二主成分に正規分布の一次微分が、第三主成分に正規分布の二次微分が現れる。
1つ目は平滑化フィルタに、2つ目はエッジ抽出フィルタに、3つ目は輪郭抽出フィルタ（Laplacian Gaussian）に対応し、脳内にもこのような応答をする細胞が存在する。

基底数を制限すると局所性が現れるため、固有空間を得ることができる。
固有空間への正射影は、次のようなメリットがある。

- 情報圧縮
    - 少数の基底ベクトルの1次結合で表現できる
- 特徴抽出
    - 顔の固有空間への正射影は人間成分の抽出になる
- 画像パターンの可視化
    - 動画像パターンセットは高ベクトル空間において多様体を形成する
- 画像復元
    - もし一部が欠落した画像でも、事前に欠落していない画像からなる特徴ベクトルに射影すれば、部分空間上の画像の中で最も近い画像を得ることができる

