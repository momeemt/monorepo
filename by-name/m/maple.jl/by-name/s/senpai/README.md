# 🐶 Senpai

![senpai.png](./senpai.png)

MarkdownファイルをLLMに渡して有用なアドバイスをもらい、Issueを作成してもらうツールです。どのようなアドバイスがされるかは以下のリポジトリのIssueを確認してください。

- [note.momee.mt](https://github.com/momeemt/note.momee.mt)

## 制約

現在は以下のような制約があります。

- `src`ディレクトリは以下の`.md`ファイルのみが対象になります
- 実行環境では`gh`コマンドが利用できる必要があります
- モデルは`gemini-2.5-pro-preview-05-06`固定です
- プロンプトは固定です

## 実行

実行には[gh](https://github.com/cli/cli)コマンドが必要です。

### GitHub Actions

GitHub Actionsのワークフローから利用できます。
実行には[Google AI Studio](https://aistudio.google.com/)で取得できるAPIキーが必要です。

```yml
name: Senpai
on:
  schedule:
    - cron: '0 15 * * *'
  workflow_dispatch:

jobs:
  senpai:
    runs-on: ubuntu-24.04
    permissions:
      contents: write
      issues: write
    steps:
      - uses: actions/checkout@v4
      - uses: momeemt/senpai/actions/senpai@main
        with:
          gemini_api_key: ${{ secrets.AI_STUDIO_API_KEY }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Nix

Flakesを有効にしたNixを使って、以下のコマンドから実行できます。

```sh
nix run "github:momeemt/senpai"
```

### バイナリのダウンロード

[タグ一覧](https://github.com/momeemt/senpai/tags)からダウンロードしたいバージョンのタグの詳細ページからバイナリをダウンロードできます。

## LICENSE

MIT or Apache-2.0
