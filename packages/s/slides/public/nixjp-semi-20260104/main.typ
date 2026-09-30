#import "../../templates/typst/main.typ": make
#let t = make(
  theme: "nix",
  icon: "ehomaki",
)
#show: t.styling

#(t.title-slide)(
  title: text(tracking: 0pt, "Nixpkgs Reference Manual") + "
を読む①（Using Nixpkgs）",
  author: "Mutsuha Asada",
  affiliation: "@mutsuha_asada",
  date: "Nix日本語コミュニティ ゼミ 2026/01/04",
)

#(t.description-slide)(title: "このシリーズ？の目的", show-toc: false)[
  - ソフトウェアやツールを学習する際に最も効率が良いのはマニュアルの初手通読（だと思っている）
  - しかしハードルが高いし、行間が広めなのでお手軽な入門記事や、手を動かすことで理解しようとしてしまう
    - 発表者は今この状態
  - このシリーズ（Nixpkgs Reference Manual を読む）では、マニュアルを通読して、必要に応じて行間を埋めて発表するという形式を取る
]

#(t.toc-slide)(depth: 2)

#(t.chapter-slide)(title: "Platform Support")

#(t.description-slide)(title: "プラットフォームに対するサポートの差異")[
  - プラットフォームごとに Tier を設定して、Tier ごとにサポート責任を分けている
  - Tier 1
    - このプラットフォームにおいてビルドエラーが発生する場合、マージやリリースをブロックする
  - Tier 2
    - 更新によってビルドが壊れないことが期待される
    - 実用レベルのサポート
  - Tier 3 〜 Tier 7
    - 更新によってビルドが壊れる可能性がある
]

#(t.description-slide)(title: "Linux は macOS より優先されている")[
  - 「x86_64-linux は最もサポートされている」というのは、x86_64-unknown-linux-gnu が唯一の Tier1 だから
  - x86_64-apple-darwin と aarch64-apple-darwin は Tier 2
]

#(t.description-slide)(title: "Tier を決定づける要素")[
  - Hydra
    - Nixpkgs の CI システム
    - Hydra がそのプラットフォーム向けのパッケージをどれだけビルドしているか
  - Ofborg
    - GitHub の PR に対して影響範囲を推定して必要なビルドを行う
    - Ofborg の対象となっているプラットフォームであるか
  - Bootstrap tarballs
    - Nixpkgs をそのプラットフォームで立ち上げるための最低限のツールチェーンが提供されているか（Tier 3 の事実上の条件？）
]

#(t.chapter-slide)(title: "Global configuration")

#(t.description-slide)(title: "Global configuration とは？")[
  - Nixpkgs はデフォルトで以下のパッケージのビルドを評価時に停止する
    - 壊れているパッケージ（`meta.broken`）
    - サポート外のプラットフォーム
    - unfree ライセンス
      - CI のビルドやビルドキャッシュによる配布が禁じられていることが多い
    - 既知の脆弱性を含むもの
]

#(t.description-slide)(title: "Global configuration とは？", show-toc: false)[
  - Global configuration は、特定のプラットフォームやパッケージについて、上のような場合でも評価するための設定
    - 個々のパッケージを毎回 override するのではなく、nixpkgs 全体に一貫した方針を与える
  - 特定のプラットフォームで動作するはずのプログラムが実際には動作しない場合、そのプラットフォームは `meta.platforms` に含めるべきだが、`meta.broken` で明示的に動作しないことを示す必要がある
]

#(t.description-slide)(title: "例外の種類")[
  - 一時的な例外
    - 環境変数（`NIXPKGS_ALLOW_*`）
  - 恒久的な例外
    - `~/.config/nixpkgs/config.nix`
  - 条件付きの例外
    - いくつかのパッケージを `Predicate` に指定して許可できる
]

#(t.description-slide)(title: "設計思想")[
  - Nixpkgs は危険なパッケージをユーザに自由に使わせたくない
  - しかし、最終的な判断はユーザに委ねている
    - 実際、Unfree なパッケージは利用する機会がかなりある
  - その判断を設定として明示させる
]

#(t.chapter-slide)(title: "まとめ")

#(t.description-slide)(title: "まとめ", show-toc: false)[
  - Nixpkgs は巨大なパッケージ集合であり、誰かのローカル環境専用には設計されていない
  - プラットフォームに Tier が割り当てられ、サポートされる程度が決まっている
  - Global configuration は以下のような仕組み
    - 危険・非互換・Unfree なパッケージの評価をデフォルトでは停止させる
    - 例外を許す場合はユーザに明示的な判断を書かせる
  - 来週は `lib` の関数の使い方を調べてみます
]