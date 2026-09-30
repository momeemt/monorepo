#import "../../templates/typst/main.typ": make
#let t = make(
    theme: "nix",
    icon: "ehomaki",
)
#show: t.styling

#(t.title-slide)(
    title: "Nix日本語コミュニティゼミ
の告知と発表募集",
    author: "Mutsuha Asada",
    affiliation: "@mutsuha_asada",
    date: "2026/01/01"
)

#(t.description-slide)(title: "勉強会をしたい")[
    - 過去に NixConf 輪読会という勉強会が Nix 日本語コミュニティで開催されていたが、現在は継続されていない
    - 今年から、毎週日曜日の夜に Nix 日本語コミュニティゼミという小さな勉強会を開催する試みをしてみたい
    - イメージとしては小さな LT 会
        - とにかく質は問わないのでスライドを作って持ってきて喋る
        - みんなでわからないことを質問する
            - 答えられた方がいいけど、わからないことがあればみんなで調べる
            - 解決しなければ宿題にする
]

#(t.description-slide)(title: "テーマ")[
    - Nix に関係していれば何でもOK
        - 個人的には座学的にちょっと勉強して話す方が良いと思う
        - 試してみた、系も良いけど Nix meetup である程度長い時間を取った発表にした方が映えるかも
    - もし思いつかないなら...
        - Nixpkgs Reference Manual を読んでみて知らなかったことを話す
            - 私は当分これをやります
        - Nix Reference Manual を読んで話す
        - Home Manager のマニュアルやソースを読む
        - 使ったことのない flake を試す
]

#(t.description-slide)(title: "いつやるか")[
    - 一応、日曜日の21:00〜22:00を想定
        - 初回は 2026/01/04 21:00〜22:00
        - でも、終わった後に投票して最も人数が多い日に開催しても良いかも
    - 発表者募集中
        - しばらくは私は毎週資料を作って何かを話します
        - みなさまも（しっかりした資料がなくても大丈夫なので）発表してみませんか！
        - 聴きに来るだけでももちろん大丈夫です👍
    - 途中参加・途中退場など構いません
]