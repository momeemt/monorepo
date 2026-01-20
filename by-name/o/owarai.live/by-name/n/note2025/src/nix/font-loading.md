# NixOSでフォントが読み込めないとき
`fc-cache -rv`

## 詳細
uguisu側で修正したnix-configurationsをoshidori側で反映させたらAlacrittyがnerd-fontsを読み込めないと怒ってきた。実際にnvim-treeのアイコンが表示されなくなっていた。
[nix-community/home-manager #6160](https://github.com/nix-community/home-manager/issues/6160)を読んだら解決した。
どうやら`home-manager switch`だけではフォントのリロードが行われないよう。

