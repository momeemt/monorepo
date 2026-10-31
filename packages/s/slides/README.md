# slides

発表に使うスライドをまとめています。

## テンプレート

![スライドテンプレートの使用例](slide.png)

このようなデザインのスライドが出力されます。

## 非公開スライドへのアクセス

非公開スライドは [sops](https://github.com/getsops/sops) を利用して暗号化されています。
もしアクセスしたい場合には、[age](https://github.com/FiloSottile/age)鍵を該当するスライドのディレクトリに配置されている`.sops.yaml`に追加する
Pull Request を送信してください。

## ライセンス

- `private/*`は以下のスライドは Proprietary（All rights reserved）です
  - 明示的な許可なしに、複製・転載・配布・共有・改変・二次利用を禁止します
- `public/*`配下のスライドは [CC0](https://creativecommons.org/public-domain/cc0/)
  でライセンスされています
- それ以外のファイルは [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0)
  でライセンスされています
