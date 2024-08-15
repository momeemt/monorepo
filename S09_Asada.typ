#set text(font: "Hiragino Sans");
#set text(size: 9pt);

= セキュリティ・キャンプ全国大会2024 成果報告書
S09 サニタイザゼミ 浅田睦葉

本報告書は、セキュリティ・キャンプ全国大会2024の活動における成果を報告するものである。

== 1. サニタイザとは
サニタイザとは、コンパイラが生成する命令列に追加の命令を挿入することで、実行時に得られる情報を元に開発者に有益な情報を提供するツールである。
サニタイザにはいくつかの種類があり、例えばC言語やC++においては未定義動作が存在し、実際に呼び出した際の挙動は実装依存であるが、事前に未定義動作を検出する命令を挿入することで、開発者に終了理由を通知し、より安全にプログラムを開発することができる。このようなサニタイザはUndefined Behavior Sanitizer (UBSan) と呼ばれる。
本ゼミでは、受講者がそれぞれ持ち寄ったコンパイラを拡張子、サニタイザを実現することを目標に活動を行った。

== 2. パフォーマンスサニタイザ
私はキャンプの期間を通してパフォーマンスサニタイザの開発を行った。
パフォーマンスサニタイザは『Warrior1: A Performance Sanitizer for C++』（Rotem, Howes, Goldblatt, 2020）で提案されたソフトウェアであり、プロファイラなどを用いて補足できるようなホットスポット（ソフトウェア全体の速度的なボトルネックになる部分）ではなく、非効率で大量に存在するパフォーマンス低下要因を、実行時に呼び出されるログを元に解析し、開発者に通知するものである。
この論文では`std::vector`や`std::string`の成長時におけるメモリの再割り当てや、Double-map lookup、配列のシフトなど十数種類の要素を検出ルールに定め、実際にLLVMやCMakeなどのソフトウェアに存在したアンチパターンを発見し、報告している。

== 3. コンパイラ
セキュリティ・キャンプでは、参加以前から開発していたOCamlコンパイラにサニタイザを実装した。
コンパイラに関する実装の詳細については省略するが、WebAssemblyのテキスト形式をターゲットにし、WasmのランタイムであるWasmtimeを用いて実行した。
四則演算、`if`式、`let (rec) in`式、Linked Listの作成、結合、標準出力・標準エラー出力への出力、型推論などをサポートしている。

```ocaml
let rec fact x =
  if x = 0 then 1 else x * (fact (x - 1))
in
  print_int32 (fact 5)
```

実際に、上に示すプログラムは以下のようなWatに変換される。

```wat
(module
  (import "wasi_snapshot_preview1" "fd_write" (func $fd_write (param i32 i32 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "proc_exit" (func $proc_exit (param i32)))
  (memory (export "memory") 1)

  ;; 組み込み関数の実装は省略

  (func $_start (local $temp1 i32) (local $temp2 i32) (local $temp3 i32)
    i32.const 5
    call $fact_879053180
    call $print_int32
  )
  (func $fact_879053180 (param $x i32) (result i32) 
    local.get $x
    i32.const 0
    i32.eq
    (if (result i32)
    (then i32.const 1)
    (else
      local.get $x
      local.get $x
      i32.const 1
      i32.sub
      call $fact_879053180
      i32.mul
    )
    )
  )
  (export "_start" (func $_start))
)
```

== 4. 検出ルール
実装した検出ルールについて説明する。
今回はLinked Listにおけるアンチパターンについて考え、実装を行った。
具体的には、以下の3つのルールである。

- Linked Listに対するランダムアクセス
  - Linked Listは次の要素へのポインタを持つデータ構造であり、長さ$n$のリストに対するランダムアクセスには時間計算量$Theta(n)$かかる
  - ランダムアクセスが頻繁に行われる場合には、配列を利用するのが適切である
- 同一の長さが変わらないLinked Listに対する`length`の計算
  - リストの長さの計算にも、同様に時間計算量$Theta(n)$を要する
  - 長さが変わらない（シャドーイングが起こらない）場合には計算結果をメモするのが適切である
- 要素数が1である右側のリストを結合する場合
  - リストの結合には、左側のリストの要素数だけ走査する必要があるが、右側のリストの要素数が1の場合にはポインタをメモしておけば計算を削減できる

== 5. 実装
持ち込んだOCamlコンパイラは表現力が十分ではないため、サニタイザを自身の言語で記述することはできなかった。
そこで、標準エラー出力に値の状態を出力し、その出力結果をPythonで記述した解析プログラムに渡して開発者に通知することにした。
例として、ランダムアクセスの検知の実装について説明する。

=== 5-1. ランダムアクセスの検知
組み込み関数として、Linked Listの最初の要素を取得する`list_head`と、次の要素のメモリ番地を取得する`list_next`を実装した。
ここで、複数の要素が真に必要な場合、`list_head`と`list_next`はおよそ同數呼び出されるが、ランダムアクセスの場合には`list_next`がコールされる回数は、`list_head`が呼び出される回数に比して多くなると考えられる。
そこで、それぞれの関数を呼び出した場合に、標準エラー出力にリストの先頭のメモリ番地と、リストが持つ値を出力した。

==== ランダムアクセスではない場合
リストの要素を毎回`print_int32`関数に渡しており、ランダムアクセスではない。

```ocaml
let rec println_int32 lst cnt =
  let v lst = list_hd lst in
  let next lst = list_next lst in
  print_int32 (v lst);
  if cnt = 0 then 0 else println_int32 (next lst) (cnt - 1)
in
discard (println_int32 [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 ] 10)
```

`head`と`next`が交互に呼び出されることがわかる。

```
[PSan : list_hd] called
1[PSan : list_next] called
[PSan : list_hd] called
2[PSan : list_next] called
[PSan : list_hd] called
3[PSan : list_next] called
[PSan : list_hd] called
4[PSan : list_next] called
[PSan : list_hd] called
5[PSan : list_next] called
[PSan : list_hd] called
6[PSan : list_next] called
[PSan : list_hd] called
7[PSan : list_next] called
[PSan : list_hd] called
8[PSan : list_next] called
[PSan : list_hd] called
9[PSan : list_next] called
[PSan : list_hd] called
10[PSan : list_next] called
[PSan : list_hd] called
11%
```

==== ランダムアクセスである場合
`get`関数は渡したインデックスの要素のみを返すため、ランダムアクセスである。

```ocaml
let rec get x lst =
  if x = 0 then list_hd lst else get (x - 1) (list_next lst)
in
print_int32 (get 19 [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20])
```

```
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_next] called
[PSan : list_hd] called
20%
```

```
❯ dune build && ./_build/default/app/app.exe tmp/rand_access.ml && wasmtime tmp/rand_access.wat 1>/dev/null 2>&1 | python3 sanitizer/psan.py
Generated WAT file: tmp/rand_access.wat
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.55
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.6
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.65
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.7
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.75
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.8
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.85
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.9
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.95
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.475
[PSan]: You seem to be doing random access to a list, you should be using an array instead of a list. Confidence: 0.475
```

簡単のため、`head`と`next`の数の比率を信頼値ということにして出力した。

== 6. 展望
この期間では実現することができなかったが、キャンプの機会を通してサニタイザの面白さに気づくことができたので、以下の機能を将来的に実装していきたい。

- 辞書やレコード、タプルなどの複雑な構造のサポート
- メモリ管理
- ブラウザで実行可能なWasmの生成
- 固定的な信頼値を利用するのではなく、複数回の実行や、提案をユーザがどの程度受け入れたかなどのフィードバックを通じて信頼値を管理し、false positiveを減らす
- Thread Sanitizerなど、他のサニタイザの実装

== 7. ソースコード
セキュリティ・キャンプで実装したプログラムについては、以下のリポジトリで公開している。

https://github.com/momeemt/wascaml
