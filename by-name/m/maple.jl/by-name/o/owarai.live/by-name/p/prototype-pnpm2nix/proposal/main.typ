#show link: underline

= GSoC 2024 Proposal: nixpkgs pnpm tooling (Project: NixOS)
Name: Mutsuha Asada
#v(-8pt)
Email: #link("mailto:me@momee.mt")
#v(-8pt)
Country and Timezone: Japan, UTC+9
#v(-8pt)
School Name and Study: University of Tsukuba, College of Information Science
#v(-8pt)
GitHub: #link("https://github.com/momeemt")

== Abstruct
pnpmはnpmと比較して#link("https://pnpm.io/#:~:text=pnpm%20is%20up%20to%202x%20faster%20than%20npm", "2倍高速");で、依存パッケージが単一のストレージから複製またはハードリンクされることでディスク領域の使用が効率的であることを主張するnodejsのパッケージマネージャです。

Nixpkgsはnpmで管理されたプロジェクトをビルドするための導出である`buildNpmPackage`や、依存関係をフェッチする導出である`fetchNpmDeps`、`fetchYarnDeps`を提供していますが、これらはpnpmに対してはほとんど互換性がなく#footnote("npmとpnpm間の差異については、後の章で説明します。");、
pnpmをビルドするための公式の手段を提供していません。
そこで私はpnpmを使ったnodejsプロジェクトで、依存関係を準備するフェッチャーと、パッケージ化を行うビルダーを追加したいと考えています。
これには以下のようなメリットがあります。

=== pnpmパッケージをより簡単に追加できるようになる
新しいfetcherをnixpkgsに追加することにより、pnpmを用いたプロジェクトを追加する貢献が、以前よりも簡単になります！

現在はそれぞれのパッケージが個別にpnpmのパッケージをフェッチしていますが、仮にバグがあればパッケージが増えるほど修正が難しくなります。
また、開発者がpnpmの挙動やFODへの理解しなければならないので、貢献は難しくなります。

2022年にpnpmをダウンロードした人は以下の通り2021年と比較して5倍に増加しており、近年はpnpmの重要性はますます増しています。

#figure(
  image("./pnpm-downloads.png"),
  caption: [
    #link("https://pnpm.io/blog/2022/12/30/yearly-update", "The year 2022 for pnpm");より引用。
  ]
)

また、既に多くのプロジェクトにpnpmが使われています。
フロントエンドフレームワークである#link("https://github.com/vuejs/core", "vuejs/core");や#link("https://github.com/sveltejs/svelte", "sveltejs/svelte");はpnpmを採用しています。
また、Nixpkgsに含まれている#link("https://github.com/Vencord/Vesktop", "Vencord/vesktop");などのツールも使っています。
他のLinuxディストリビューションと比較して巨大なリポジトリであるnixpkgsが今後も幅広いソフトウェアをサポートするために、pnpmのツールが整備されることが重要です。

さらに、pnpmユーザにとってもNixでパッケージングできることは有益です。
pnpmはロックファイルによってバージョンや整合性ハッシュを用いて依存ライブラリを管理できますが、Nixはnodejsライブラリだけでなくビルドに関わるソフトウェア全ての再現性を保証しています。
たとえば画像処理ライブラリであるsharpは、ビルド中にプラットフォームに応じたバイナリをダウンロードしますが、それによりローカル環境とCI環境で異なる動作を引き起こすことがあります。
nodejsを用いた開発者はこのような再現性のないビルドによって悩まされている人が多くいるため、NixがpnpmをサポートすればNixユーザが増加する一因になる可能性もあります。

=== ビルドツールの共通化
上手くいけば、nodejsのビルドツールを共通化できるかもしれません。
現在は`fetchNpmDeps`や`fetchYarnDeps`、その他Nixpkgs外にある多数のツールは独立して実装されています。

`fetchNpmDeps`は上手く動作しているように見えます。
JavaScriptのエコシステムは比較的スピードを持って変化するので、pnpm以外の新しいツールが出現するかもしれませんが、`fetchPnpmDeps`を`fetchNpmDeps`を参考にして作ることで、nodejsパッケージマネージャをNixで扱うための共通の処理をライブラリとして括り出せるかもしれません。

== これまでの取り組み
まず、これまでのNixコミュニティのpnpmツールへの取り組みを整理します。

=== `pnpm2nix`
#link("https://github.com/nix-community/pnpm2nix", "pnpm2nix")は、pnpmのロックファイルをNix式に変換するツールです。
ロックファイルを出力できるパッケージマネージャを持つプログラミング言語に対しては、このアプローチがよく採用されます。
このツールは4年前まで更新されていましたが、現在は更新されていません。
#link("https://github.com/pnpm/pnpm/issues/1035", "pnpm/pnpm #1035")で述べられているように、pnpmには整合性ハッシュ（`integrity`）がロックファイルに記載されないことがあるという問題があり、個別のパッケージをビルドすることができないのです。

=== `fetchPnpmDeps`
pnpmの問題を回避するために、fixed output derivation（以下、FOD）を用いることが考えられます。
Nixは通常のビルドでは再現性を確保するためにネットワークに接続することを禁止しますが、依存するソフトウェアをインストールする必要がある場合にはこの制限は非常に厄介です。
そこで、得たいファイルのハッシュ値をあらかじめ示してからネットワーク経由でファイルを取得し、同一のファイルが得られたかどうかをチェックすることができます。これをFODと呼びます。
最近提出された#link("https://github.com/NixOS/nixpkgs/pull/290715", "NixOS/nixpkgs #290715")はFODを用いた依存パッケージのフェッチャーです。

これで問題は解決しているように思えますが、pnpmのバージョンが変更された場合に依存解決が同様に行われる保証がありません。
パッケージのフェッチに`pnpm install`を使用していますが、仮に`pnpm`の実装や依存ライブラリが変化すればビルドが再現しない可能性があります。

== 技術的な説明
これらの問題を解決するために、pnpmのロックファイルを解析してpnpmのグローバルストアを作成する、独自のFODフェッチャーを定義します。
`fetchNpmDeps`は提供されていますが、npmとpnpmには互換性が無いので新しくpnpm用に用意する価値があります。

=== npmとpnpmの違い
具体的には、npmとpnpmの間には以下のような違いがあります。

- ロックファイル
  - npmは`package-lock.json`というJSON形式のロックファイルを生成しますが、pnpmは`package-lock.yaml`というYAML形式のロックファイルを生成します。
- ディレクトリ構造
  - npmは依存パッケージをフラットな構造で`node_modules`に保持しますが、pnpmはディスク容量を節約するためにストレージから複製またはハードリンクして入れ子構造で保持します。
  - 具体的にはpnpmの公式ブログである#link("Flat node_modules is not the only way", "https://pnpm.io/blog/2020/05/27/flat-node-modules-is-not-the-only-way")に記載されています。

=== グローバルストア
`pnpm install`コマンドを使用する代わりに、新しく実装するフェッチャーがグローバルストアを`$out`に作成して、`pnpm config set store-dir $out`コマンドを実行します。
pnpmのグローバルストアのパスは、私の環境では`~/Library/pnpm/store/v3`であり、`pnpm store path`コマンドにより調べることができます。
`~/Library/pnpm/store/v3/files/`には、ハッシュ値の上2文字（16進数2桁の整数）のディレクトリが多くあります。

pnpmによってインストールされたパッケージに含まれるファイルは、まずハッシュ値が計算されます。
https://github.com/pnpm/pnpm/blob/d4e13ca969ebab5da630c1351f8ed9a89a975108/store/cafs/src/getFilePathInCafs.ts#L25-L31

その次に、ハッシュ値によってファイル名が決定してグローバルストアに格納されます。
https://github.com/pnpm/pnpm/blob/d4e13ca969ebab5da630c1351f8ed9a89a975108/store/cafs/src/getFilePathInCafs.ts#L17-L23

また、ロックファイルに整合性ハッシュがないパッケージは、グローバルストアに格納される段階で`integrity.json`が作成されるので同じように処理されます。

=== `fetchNpmDeps`
フェッチャーの実装には`fetchNpmDeps`を参考にします。特に注目する部分について説明します。

この関数は、ロックファイルを解析して依存するパッケージ（`Package`型）に変換します。
https://github.com/NixOS/nixpkgs/blob/2b3db9aeca054ae93126354e666394854edf5357/pkgs/build-support/node/fetch-npm-deps/src/parse/mod.rs#L18-L22

`Package`はパッケージ名、URL、整合性ハッシュを持っています。
https://github.com/NixOS/nixpkgs/blob/918363e6fced7ae9e27c6b0c36195c2f9f94adde/pkgs/build-support/node/fetch-npm-deps/src/parse/lock.rs#L72-L78

pnpmの場合はロックファイルがYAML形式ですが、デシリアライズにはserdeライブラリを使用しています。serdeはJSONターゲットのserde_jsonと、YAMLターゲットのserde_yamlがあるので、コストを掛けずにpnpmにも対応できます。

また、pnpmのグローバルストアを実装するにあたり、`fetchNpmDeps`が持つキャッシュを操作するプログラムが非常に参考になります。
https://github.com/NixOS/nixpkgs/blob/918363e6fced7ae9e27c6b0c36195c2f9f94adde/pkgs/build-support/node/fetch-npm-deps/src/cacache.rs#L54-L124

=== `pnpm2nix`との比較
`pnpm2nix`はロックファイルをNix式に変換するアプローチを取っているので、FODフェッチャーと比較してNixのエコシステムとの統合が容易です。
NixOSや他のNixベースのシステムでも依存パッケージのビルドを移植でき、拡張することもできます。
しかし、`pnpm2nix`はロックファイルに完全に依存しており、全てのパッケージの整合性ハッシュが記述されている必要があります。
現に、pnpmには#link("https://github.com/pnpm/pnpm/issues/1035", "pnpm/pnpm #1035")という問題があります。
総合的に判断すると、新しいFODフェッチャーに注力する方が良いでしょう。

=== `fetchPnpmDeps`との比較
現在提出されている`fetchPnpmDeps`には、pnpmのバージョンが違うと依存性解決の方法が変わる可能性があり、ビルドの再現性が十分に保証できないことが問題点として挙げられます。
このフェッチャーと比較すると、新しいFODフェッチャーはロックファイルからpnpmのグローバルストアを作成するので、pnpmのバージョンが異なっても同じように依存性が解決されます。
さらに、新しいフェッチャーは新しいグローバルストアを別に作成するので、他のプロジェクトが依存するライブラリと混ざりません。唯一のストアからハードリンク、または複製を行うことはディスク容量を節約するという点において賢い方法ですが、ビルドの再現性を犠牲にしています。
したがって、`fetchPnpmDeps`と比較して非常に高いビルドの再現性、依存解決の正確性を得ることができるでしょう。

== 目標

=== Primary

==== 新しいpnpm向けのFODフェッチャーを実装する
ここまで説明した通り、新しいpnpm向けのFODフェッチャーを実装します。
具体的にはロックファイルを解析してグローバルストアを構成することで、pnpmのバージョンが変わっても同一の依存性解決を保証します。

==== ソースコードドキュメントの整備
GSoC期間中に、nixpkgsにマージされる水準のFODフェッチャーを実装することは難しいかもしれません。期間後も継続するつもりですが、私は他のユーザが私のコードを読んで改善することができるようにソースコードのドキュメントを整備します。
特に、pnpm固有の知識については適切な参照やコメントが必要となるでしょう。

==== ドキュメントの整備
ソースコードドキュメントだけでなく、フェッチャーを利用するユーザのためにnodejsページにドキュメントを加える必要があります。

=== Extra

==== 既存のpnpmプロジェクトに対して実装したpnpmフェッチャーを使用する
テストとして、いくつかのロックファイルから正しいグローバルストアを作成できるのか、ビルドに再現性があるかなどのテストを行います。
その後、既存のpnpmプロジェクトに対して実装したフェッチャーを使用し、問題がないかどうかを確かめます。
そうすれば、実装したフェッチャーが実用に耐えることが部分的に証明できます。

=== Hard

==== pnpm/pnpm \#1035の解決
新しいpnpm向けのFODフェッチャーを実装するには、pnpmの実装によく目を通す必要があります。
したがって、この課題に取り組むことでpnpmについての解像度も深まるのでバグや新しい機能を実装できる可能性が高まります。
pnpm2nixを動作させるためにpnpm/pnpm \#1035の解決を図ることは、再現性を高めるのでもちろんpnpmユーザにとっても、Nixコミュニティにとっても有益です。

開発が順調に進めば取り組んでみたいと考えています。

==== アナウンスを行う
新しいFODフェッチャーが実装できて、ドキュメントやテストを整備できた場合には、多くのユーザにそれを知らせるためにアナウンスを行う必要があります。

== Project Schedule (bi-weekly)

=== May 1 to May 20
プロジェクトの準備期間。pnpmのソースを読んでグローバルストアの実装を理解します。
また、ビルドの再現性を高めるための設計を検討します。

=== May 21 to June 3
プロジェクトを開始します！
pnpmのロックファイルの解析を実装します。また、パッケージのtarballをダウンロードします。

=== June 4 to June 17
ダウンロードしたパッケージの整合性ハッシュを計算して、グローバルストアを作成します。
依存が存在しない単一のパッケージをビルド可能にすることが目標です。

=== June 18 to July 1
引き続き、グローバルストアを作成します。
依存が複雑に存在するパッケージをビルド可能にすることが目標です。

=== July 2 to July 15
`buildNpmPackage`に対応するビルダーを作成します。
簡単なpnpmパッケージのビルドが正しく動作することを確認するのが目標です。

=== July 16 to July 29
引き続き、ビルダーを作成します。
依存が複雑に存在する、実際にnixpkgsに取り込まれたpnpmパッケージのビルドが正しく動作することを確認するのが目標です。

=== July 30 to August 12
新しいフェッチャーとビルダーのドキュメントを作成します。
既存のpnpmパッケージなど、例を含めて誰でも使い始められるようにすることが目標です。

=== August 13 to August 26
上記のスケジュールを完璧に実行することは難しいと思います。
作業に何らかの事故や遅延が生じる可能性があります。
そこで、この期間をバッファとして残します。
余裕があれば、pnpm/pnpm \#1035の解決や、マージに向けた修正に取り組んでいきたいと思います。

== Experience
=== OSS Contributions
私はGitHubで複数のソフトウェアを開発しています。その中には複数人で開発したものや、ユーザからPull Requestsを受けているものもあります。

#link("https://github.com/momeemt")

もしGSoCで良い経験ができれば、NixpkgsだけでなくNix本体や周辺ツールにも貢献できるようになりたいと思っています。普段からNixを使って開発していて、現在は自宅サーバをNixOSに置き換えている最中です。

==== Brack Language (Aug. 2022 to present)
In the development of Brack, a markup language designed to simplify the creation of domain‒specific documents, I’ve taken a leadership role. Starting as a solo project, I spent over a year refining its design and implementation, focusing on a syntax that enables easy command invocation through Wasm binaries. Recently, the project has evolved into a collaborative effort, where I’ve been responsible for integrating advanced features like the Language Server Protocol, delegating tasks such as LSP implementation and documentation to my partner. This approach has significantly improved the functionality and usability of Brack, offering an efficient alternative to traditional document creation methods. (Rust, WebAssembly, Nix) [repo]

==== Sohosai (Mar. 2022 to Oct. 2023)
At our university festival, I led a 10‒person team to implement a new email system and develop a web platform, streamlining communications and information management for over 30,000 attendees. We successfully introduced personalized emails with enhanced security and a visitor‒friendly website with maps and event schedules, significantly improving festival operations. The projects, involving challenges like integrating advanced features cost‒effectively, were completed within tight deadlines. My role encompassed strategic planning, overseeing technical implementation, and adapting to unexpected changes, ensuring both initiatives enhanced visitor experience and operational efficiency. (Rust, Nix, Terraform, Docker, Roundcube, Sakura Cloud) [Website] [GitHub]

==== mock up (Mar. 2021 to Dec. 2023)
Developed “mock up,” a versatile framework for video editing using JSON/YAML, utilizing Nim and GLSL for easy plugin development and ensuring high extensibility. This framework allows for the conversion of data to standard formats, facilitating the integration of video processing capabilities into existing systems. Dedicated two years to this project as a solo endeavor, focusing on the proactive design of plugins that can be easily implemented with minimal code and GLSL, streamlining the addition of advanced video editing features. (Nim, FFmpeg, OpenGL) [repo]

==== Piledit (Mar. 2020 to Mar. 2021)
Together with a friend, I co‒developed “Piledit,” a block‒based video editing software inspired by observing a high school student’s difficulties with traditional editing tools. Aimed at offering an intuitive editing solution, Piledit has been notably accessible for students, providing an easier alternative to software like AviUtl. Over the course of a year, we divided our efforts: I focused on the frontend, designing block behaviors and data conversion, while also overseeing the project direction and distributing tasks, including backend development. (TypeScript, Electron, C\#, ASP.NET) [frontend] [backend] [pdf(ja)]

=== Work Experience

==== 筑波大学情報学群情報科学類 (Dec. 2022 to May 2023)
In the university’s freshman welcome committee, we created a pamphlet and organized events to help new students acclimate. We used GitHub for a consistent and reproducible writing process. The pamphlet took two of us three months to produce, and organizing events required a three‒person team for four months. My contributions included coordinating with department contributors, managing schedules, and setting up the collaborative environment. (SATySFi, dune, Docker, GitHub Actions)

==== Security minicamp Tutor (Sep. 2022)
Assisted lectures as a tutor for the Security Camp, a training program conducted by the Ministry of Economy, Trade and Industry.

==== PIXIV Summer Internship (Aug. to Sep. 2022)
At PIXIV, I enhanced the ImageFlux image processing service by integrating FFmpeg and OpenH264, enabling it to compress and output mp4 files using the H.264 codec, in addition to its existing GIF animation conversion capability. This development responded to the growing demand for video content on the web and significantly increased the efficiency of video file conversions, achieving speeds up to 12 to 19 times faster than before. The upgrade greatly benefited users engaged in web‒based content distribution. I completed this project independently in just seven days, focusing on incorporating FFmpeg into the existing system, evaluating various technical options including existing wrapper libraries and cgo, to ensure the program’s quality. (Go, C, bash, FFmpeg, OpenH264) [pdf(ja)]

==== Invast Inc. Internship (Jan. to Sep. 2022)
I participated in the development of an application related to securities education. I was in charge of examining and correcting bugs based on feedback from actual users. (TypeScript, Vue.js)
