module PastActivity where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import Language (Language, s, tx)

past_activity_li :: forall m. String -> Component m -> Component m
past_activity_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

past_activity :: forall m. Language -> Component m
past_activity language = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    tx language "Activities" "過去の活動"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    past_activity_li (s language "Security Camp 2026 Mini Camp in Osaka lecturer, \"Build Your Own Build System\" (2026/03/14)" "セキュリティ・キャンプ2026 ミニキャンプ in 大阪 講師『ビルドシステムを自作しよう』(2026/03/14)") do
      JE.li' do
        text "2026/03/14 9:00 - 17:00"
      JE.li' do
        tx language
          "I taught a session where students extend a small build system and implement features such as incremental builds, lock files, and build caches."
          "小さなビルドシステムを拡張し、インクリメンタルビルド、ロックファイル、ビルドキャッシュなどの機能を実装する講義を担当しました"
      JE.li' do
        external_link "https://www.security-camp.or.jp/minicamp/osaka2026.html" do
          tx language "Official website" "公式Webサイト"
    past_activity_li (s language "ICTSC2025 Final Round, 7th place (2026/03)" "ICTSC2025 本戦 7位 (2026/03)") do
      JE.li' do
        tx language "University of Tsukuba, Azuma Elementary School-mae (tentative)" "筑波大学 吾妻小学校前（仮）"
      JE.li' do
        external_link "https://icttoracon.net/archives/10414" do
          tx language "Results announcement" "結果発表"
    past_activity_li (s language "Nix meetup #4 talk, \"❄️ Attending NixCon 2025\" (2025/10/17)" "Nix meetup #4 登壇『❄️ NixCon2025に参加した』(2025/10/17)") do
      JE.li' do
        external_link "https://speakerdeck.com/momeemt/nixcon2025nican-jia-sita" do
          tx language "Slides" "スライド"
      JE.li' do
        tx language "Presented a report on attending NixCon 2025" "NixCon 2025の参加報告をしました"
    past_activity_li (s language "NixCon 2025 talk, \"Applying Graph2Diff neural repair to build errors in nixpkgs\" (2025/09)" "NixCon 2025 登壇『Applying Graph2Diff neural repair to build errors in nixpkgs』(2025/09)") do
      JE.li' do
        external_link "https://talks.nixcon.org/nixcon-2025/talk/WUFEPF/" do
          tx language "Talk page" "発表ページ"
      JE.li' do
        tx language "Presented the application of Graph2Diff neural repair to nixpkgs build errors" "nixpkgsのビルドエラーに対するGraph2Diffニューラル修復の適用について発表しました"
    past_activity_li (s language "Cybozu Lab Youth, 14th term, language-processing systems seminar (2024/06 - 2025/06)" "サイボウズ・ラボユース 14期 言語処理系開発ゼミ (2024/06 - 2025/06)") do
      JE.li' do
        external_link "https://labs.cybozu.co.jp/youth/requirements.html" do
          tx language "Developed Brack, a markup language extensible with WebAssembly" "WebAssemblyで拡張可能なマークアップ言語 Brackの開発"
    past_activity_li (s language "Nix meetup #3 talk, \"❄️ Learning NixOS modules through tmux-nix\" (2025/05)" "Nix meetup #3 登壇『❄️ tmux-nixの実装を通して学ぶNixOSモジュール』(2025/05)") do
      JE.li' do
        external_link "https://nix-ja.connpass.com/event/353532/" do
          tx language "Nix meetup #3 Osaka" "Nix meetup #3 大阪"
        text " / "
        external_link "https://speakerdeck.com/momeemt/tmux-nixnoshi-zhuang-wotong-sitexue-bunixosmoziyuru" do
          tx language "Slides" "スライド"
      JE.li' do
        tx language "Explained the implementation of a NixOS module for describing tmux configuration in Nix" "ターミナルマルチプレクサのtmuxの設定をNixで記述するためのNixOSモジュールの実装について説明しました"
    past_activity_li (s language "Nix meetup #2 talk, \"❄️ Implementing SATySFi support in NixOS/nixpkgs\" (2025/03)" "Nix meetup #2 登壇『❄️ NixOS/nixpkgsにSATySFiサポートを実装する』(2025/03)") do
      JE.li' do
        external_link "https://nix-ja.connpass.com/event/342908/" do
          text "Nix meetup #2"
        text " / "
        external_link "https://speakerdeck.com/momeemt/nixpkgsni-satysfisapotowoshi-zhuang-suru" do
          tx language "Slides" "スライド"
      JE.li' do
        tx language "Explained and compared Nix build support implementations for SATySFi packages" "組版システムであるSATySFiのパッケージのNixビルドサポートの比較と実装について説明しました"
    past_activity_li (s language "Open Source Conference 2024 Tokyo/Fall exhibitor (2024/10)" "オープンソースカンファレンス2024 Tokyo/Fall 出展 (2024/10)") do
      JE.li' do
        tx language "Exhibited the Brack language at the Cybozu Lab Youth booth" "サイボウズ・ラボユースのブース内で、Brack言語の展示を行いました"
      JE.li' do
        external_link "https://event.ospn.jp/osc2024-fall/exhibit#:~:text=%E3%82%B5%E3%82%A4%E3%83%9C%E3%82%A6%E3%82%BA%E3%83%BB%E3%83%A9%E3%83%9C%E6%A0%AA%E5%BC%8F%E4%BC%9A%E7%A4%BE,%E3%82%92%E8%A1%8C%E3%81%84%E3%81%BE%E3%81%99%E3%80%82" do
          tx language "Official website" "公式Webサイト"
    past_activity_li (s language "Security Camp National Convention 2024 (2024/08)" "セキュリティ・キャンプ全国大会2024 (2024/08)") do
      JE.li' do
        tx language "S09 Build Your Own Sanitizer seminar (lecturers: " "S09 サニタイザ自作ゼミ (講師: "
        external_link "https://github.com/m1kit" do
          text "@m1kit"
        tx language ", co-seminar: " ", 同ゼミ: "
        external_link "https://github.com/jippo-m" do
          text "@jippo_m"
        text ")"
    past_activity_li (s language "GEEK CAMP Hackathon, Grand Prize (2022/12)" "技育CAMPハッカソン 最優秀賞 (2022/12)") do
      JE.li' do
        tx language "Responsible for frontend design, logo design, slides, and presentation" "担当: フロントエンドのデザイン、ロゴ作成、スライド作成、発表"
      JE.li' do
        text "GitHub: "
        external_link "https://github.com/momeemt/girigiri-meshi" do
          text "momeemt/girigiri-meshi"
        text " w/"
        external_link "https://github.com/sonarAIT" do
          text "@sonarAIT"
        text ", "
        external_link "https://github.com/TakabayaP" do
          text "@TakabayaP"
    past_activity_li (s language "Technical Book Fair 13 circle participation (2022/09)" "技術書典13 サークル参加 (2022/09)") do
      JE.li' do
        tx language "\"Metaprogramming Nim\" - momeemt" "『メタプログラミングNim』 - momeemt"
      JE.li' do
        external_link "https://techbookfest.org/product/9MmhQfKjFRcRUFChKUqDLM?productVariantID=tMP44hVh3xbeKv8D8eLTqP" do
          tx language "Official page" "公式サイト"
    past_activity_li (s language "SWEST24 lecturer (2022/09)" "SWEST24 講師 (2022/09)") do
      JE.li' do
        tx language "Led a Nim language session at an embedded-systems residential workshop" "組み込みシステムの合宿方ワークショップでNim言語のセッションを担当させていただきました"
      JE.li' do
        external_link "https://swest.toppers.jp/SWEST24/program/s5b.html#s5" do
          tx language "2022/09/02 session s5b" "2022/09/02 セッションs5b"
    past_activity_li (s language "Security Mini Camp in Yamanashi 2022 tutor (2022/09)" "セキュリティ・ミニキャンプ in 山梨 2022 チューター (2022/09)") do
      JE.li' do
        tx language "Assisted lecturers and supported students" "講師のヘルプ、受講生のサポートなど"
      JE.li' do
        external_link "https://www.security-camp.or.jp/minicamp/yamanashi2022.html" do
          tx language "Official website" "公式Webサイト"
    past_activity_li (s language "WCCE2022 poster presentation (2022/08)" "WCCE2022 ポスター発表 (2022/08)") do
      JE.li' do
        tx language "Presented a poster about my work in Joho Kagaku no Tatsujin" "情報科学の達人で取り組んだ内容についてポスター発表する機会をいただきました"
      JE.li' do
        external_link "https://wcce2022.org/" do
          tx language "Official website" "公式サイト"
    past_activity_li (s language "Joho Kagaku no Tatsujin (2021/05 - 2022/02)" "情報科学の達人 (2021/05 - 2022/02)") do
      JE.li' do
        external_link "https://www.ipsj.or.jp/event/taikai/84/84PosterSession/contents/pdf/8094.pdf" do
          tx language "\"Optimize saliency in specified regions in images\"" "『特定領域における顕著性の最適化』"
        tx language ", IPSJ National Convention 84th" ", 情報処理学会第84回全国大会"
      JE.li' do
        tx language "Mentor: " "メンター: "
        external_link "https://github.com/yonetaniryo" do
          text "@yonetaniryo"
    past_activity_li (s language "Mitou Junior (2021/06 - 2021/11)" "未踏ジュニア (2021/06 - 2021/11)") do
      JE.li' do
        external_link "https://jr.mitou.org/projects/2021/mock_up" do
          tx language "mock up: video-editing software framework" "mock up: 動画編集ソフトウェアフレームワーク"
      JE.li' do
        tx language "Mentor: " "メンター: "
        external_link "https://github.com/kyasbal" do
          text "@kyasbal"
    past_activity_li (s language "GEEK TEN 2021, Grand Prize (2021/10)" "技育展2021 最優秀賞 (2021/10)") do
      JE.li' do
        tx language "Business-launch track " "事業化目指してます部門 "
        JE.span ["class" := "text-slate-400"] do
          tx language "(not aiming for that now)" "(今は目指していません)"
      JE.li' do
        external_link "https://talent.supporterz.jp/geekten/2021/" do
          tx language "Official website" "公式Webサイト"
    past_activity_li (s language "Security Camp National Convention 2021 Online (2021/08)" "セキュリティ・キャンプ全国大会2021 オンライン (2021/08)") do
      JE.li' do
        tx language "Y-I Build Your Own OS seminar (lecturer: " "Y-I OS自作ゼミ (講師: "
        external_link "https://github.com/uchan-nos" do
          text "@uchan-nos"
        text ")"
    past_activity_li "SecHack365 (2020/05 - 2021/02)" do
      JE.li' do
        external_link "https://sechack365.nict.go.jp/achievement/2020/pdf/2020_10.pdf" do
          tx language "Beginner-friendly component-oriented video-editing software" "初心者にもやさしいコンポーネント指向 動画編集ソフトウェア"
      JE.li' do
        tx language "Learning-driven course, Sakai seminar (lecturer: " "学習駆動コース 坂井ゼミ (講師: "
        external_link "https://kozos.jp/" do
          tx language "Hiroaki Sakai" "坂井弘亮さん"
        text ")"
    past_activity_li (s language "Technical Book Fair 10 circle participation (2020/12 - 2021/01)" "技術書典10 サークル参加 (2020/12 - 2021/01)") do
      JE.li' do
        tx language "\"NimXD Book1\", \"NimXD Book2\" - momeemt" "『NimXD Book1』, 『NimXD Book2』 - momeemt"
      JE.li' do
        text "w/"
        external_link "https://github.com/50m-regent" do
          text "@50m-regent"
      JE.li' do
        external_link "https://techbookfest.org/organization/5762036657029120" do
          tx language "rm circle page" "あーるえむ サークルページ"
    past_activity_li "Life is Tech! (2018 - 2019)" do
      JE.li' do
        text "Unity → Web Design"
      JE.li' do
        external_link "https://life-is-tech.com/news/member/2019-memberinterview-04" do
          tx language "Interview article" "インタビュー記事"
    past_activity_li "Tiprint (2018 - 2019)" do
      JE.li' do
        tx language "A media site for articles about Minecraft Bedrock Edition" "Minecraft 統合版に関する記事を投稿するメディア"
      JE.li' do
        external_link "https://web.archive.org/web/20190411042137/https://tiprint.net/" do
          text "tiprint.net (Wayback Machine)"
    past_activity_li (s language "Science and Mathematics Research Lab, intensive program (2019/08)" "理数研究ラボ 集中型 (2019/08)") do
      JE.li' do
        tx language "Studied and presented on RSA and elliptic-curve cryptography" "RSA暗号、楕円曲線暗号の学習と発表など"
