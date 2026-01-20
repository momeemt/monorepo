# 文書の特徴ベクトル化

## Bag-of-words

文書中に含まれる単語について、頻度によらず出現したかどうかのみを特徴とするベクトルを**Bag-of-words**という。

## TF-IDF

Bag-of-wordsベクトルの出現フラグの代わりに、単語の出現頻度や珍しさを反映した値を持つベクトルを**TF-IDF**という。
情報検索分野でも頻出。

- N個の文書 $D = \{d_1, d_2, \dots, d_N\}$
- $n_{ij}$ は、$j$番目の文書における語$i$の出現回数
- TF (term freq.)
    - 語$i$の文章$j$における出現割合
    - $\text{tf}_{ij} = \frac{n_{ij}}{\sum_{d_k \in D} n_{kj}}$
- IDF (inv. doc. freq.)
    - 語$i$の珍しさ
    - $\text{idf}_i = \frac{N}{\left| \{d | i \in d, d \in D\} \right|}$
- TF-IDF
    - 語$i$の文書$j$における重要さ
    - $\text{tfidf}_{ij} = \text{tf}_{ij} \times \text{idf}_{i}$

