# nixpkgs レビューログ
[NixOS/nixpkgs](https://github.com/NixOS/nixpkgs)のレビュー時に見逃していた・気を付けるべき点について記録しておく。

## 習慣
- できるだけ起床してから30〜60分間はnixpkgsへのレビューに充てる
    - 朝の方が当日中に他のレビュワーやコントリビュータからの返信に対応しやすい
- [ ] バージョン更新だけなど、レビューしやすいPRは作業の合間に取り組みたい...
    - まだ`nixpkgs-review`が実行されていないPRに対して自動で実行しておくツールが欲しい
- 過去にレビューしたPRの更新や、レビュワーから指摘にはできるだけ優先的に対応する
    - これが苦手なのが課題

## 一般
- Approveしてから他のレビュワーによって改善点が指摘された場合にはメモしておく
- Request Changesを送ってからマージされるまではTodoistに入れて確認するようにする
- Approveしてからコミッタにマージされない場合はNixOS Discourseの[prs-ready-for-review](https://discourse.nixos.org/t/prs-ready-for-review/3032)に投稿する
- Request Changesを送る際にはできるだけ丁寧に改善点について説明する

## ログ

### 2025/06/10
- [x] [ocamlPackages.ancient: init at 0.10.0](https://github.com/NixOS/nixpkgs/pull/415530)
- [ ] [ocamlPackages.amqp-client: init at 2.3.0](https://github.com/NixOS/nixpkgs/pull/415510)

### 2025/06/09
- [ ] [ocamlPackages.kcas: 0.6.1 -> 0.7.0](https://github.com/NixOS/nixpkgs/pull/415137)
- [x] [ocamlPackages.{landmarks, landmarks-ppx}: 1.4 -> 1.5](https://github.com/NixOS/nixpkgs/pull/415138)
- [ ] [ocamlPackages.mmap: 1.1.0 -> 1.2.0](https://github.com/NixOS/nixpkgs/pull/415186)
    - `useDune2`は古いので削除

### 2025/06/08
- [x] [ocamlPackages.dum: 1.0.1 -> 1.0.3](https://github.com/NixOS/nixpkgs/pull/414913)
    - `substituteInPlace`に対するオプション`--replace`は非推奨になったので、`--replace-fail`などの[オプション](https://nixos.org/manual/nixpkgs/stable/#fun-substitute)を使う。[ref](https://github.com/NixOS/nixpkgs/pull/414913#discussion_r2140294804)
- [ ] [ocamlPackages.eigen: 0.2.0 -> 0.3.3](https://github.com/NixOS/nixpkgs/pull/414921)

### 2025/06/07
- [x] [ocamlPackages.mirage-crypto: 1.2.0 -> 2.0.1](https://github.com/NixOS/nixpkgs/pull/414541)
- [ ] [ocamlPackages.awa: 0.5.1 -> 0.5.2](https://github.com/NixOS/nixpkgs/pull/414639)
- [x] [ocamlPackages.benchmark: 1.6 -> 1.7](https://github.com/NixOS/nixpkgs/pull/414669)
- [ ] [ocamlPackages.bitwuzla-cxx: 0.6.1 -> 0.8.0](https://github.com/NixOS/nixpkgs/pull/414671)
- [ ] [ocamlPackages.cow: 2.4.0 -> 2.5.0](https://github.com/NixOS/nixpkgs/pull/414675)
- [ ] [ocamlPackages.directories: 0.5 -> 0.6](https://github.com/NixOS/nixpkgs/pull/414677)

### 2025/06/06
- [ ] [ocamlPackages.encore: 0.8 -> 0.8.1](https://github.com/NixOS/nixpkgs/pull/414532)

### 2025/06/05
- [ ] [ocamlPackages.lua-ml: 0.9.2 -> 0.9.4](https://github.com/NixOS/nixpkgs/pull/414245)
    - `odoc`はドキュメント生成のみに必要（`with-doc`）なので、`buildPhase`には必要ないことがある

### 2025/06/04
- [x] [ocamlPackages.wasm: 2.0.1 -> 2.0.2](https://github.com/NixOS/nixpkgs/pull/413741)
    - opamパッケージとしてビルドされているが、upstreamがduneプロジェクトの場合には`buildDunePackage`を用いて書き直した方が良い
- [x] [ocamlPackages.ffmpeg: 1.2.1 -> 1.2.5](https://github.com/NixOS/nixpkgs/pull/413753)
    - `meta.changelog`は、テキスト形式の方が扱いやすいので、`https://raw.githubusercontent.com/`で指定した方が良い
- [ ] [ocamlPackages.xenstore: 2.3.0 -> 2.4.0 (draft)](https://github.com/NixOS/nixpkgs/pull/413745)
    - xenstore-toolがバージョンアップによって消されたAPIを使っていて、かつ報告場所がないので困っている、という旨のコメントをOCamlパッケージをメンテナンスしてる方に投げてみた
- 30分くらいのつもりだったけど2時間経っていた
- SATySFi
    - [satysfiDirs.ml](https://github.com/na4zagin3/satyrographos/blob/196244437adaf81d89b3081dd8a26a45e02d1b24/src/satysfi/satysfiDirs.ml#L31-L43)
    - ここで~/.opam/<ocaml-version>配下のパッケージパスを特定している
    - `SATYSFI_RUNTIME`を書き換えると出力先を選べる
    - Pythonスクリプト不要かも。satyrographosに処理を委譲できそう

