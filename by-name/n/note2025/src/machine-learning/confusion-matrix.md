# 混同行列と性能評価

2値分類問題の分類結果をまとめた行列。

- 予測が真
    - 実際も真
        - TP: True positive
    - 実際は偽
        - FP: False positive
- 予測が偽
    - 実際は真
        - FN: False negative
    - 実際も偽
        - TN: True negative

## 正解率: accuracy

予測がどの程度当たったかを示す指標を正解率という。

$$
\text{accuracy} = \frac{\text{TP} + \text{TN}}{\text{TP} + \text{FP} + \text{FN} + \text{TN}}
$$

## 精度: precision

真と予測したデータのうち、実際に真である割合を精度という。
取りこぼしても良い = False negativeは許容するが、間違いが許されない場合に使う。

$$
\text{precision} = \frac{\text{TP}}{\text{TP} + \text{FP}}
$$

## 偽陽性率: false positive rate

実際は偽であるにも関わらず真であるように予測してしまった事例の割合。

$$
\text{false positive rate} = \frac{\text{FP}}{\text{TN} + \text{FP}}
$$

## 再現率: recall

実際に真であるもののうち、真と予測した割合。
予測が間違っても良いが、取りこぼしが許されない場合に使う。

$$
\text{recall} = \frac{\text{TP}}{\text{TP} + \text{FN}}
$$

## F値: F-measure

$$
\text{F} = \frac{2 *\text{Recall} * \text{Precision}}{\text{Recall} + \text{Precision}}
$$

精度と再現率の調和平均で、総合的な評価に使われる。
精度と再現率を両方高くすることは難しい。

## ROC曲線

閾値を変えながらFPとTPをプロットした曲線。
ROC曲線の下の面積を**AUC**: Area Under the Curveと呼び、性能評価として用いる。
AUCが広いほど良い分類器であると言える。
正解率の評価と同様に訓練事例で学習し、テスト事例でAUCを評価する。K-fold CVを使っても良い。

## 使い分け

- 分類器の性能を閾値に依存せずに評価したい
    - AUC
- 分類器の性能を特定の閾値について評価したい
    - 2クラスの重要度が同じ場合
        - 精度
    - どちらかのクラスがより重要である場合
        - 予測の質が重要なら精度
        - 取りこぼさないことが重要なら再現率
        - どちらも着目したい場合はF値

