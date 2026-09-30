module Software where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import Language (Language, s, tx)

software :: forall m. Language -> Component m
software language = do
  JE.div ["class" := "mt-4"] do
    JE.h2 ["class" := "text-2xl"] do
      tx language "Software" "ソフトウェア"
    JE.ul ["class" := "list-disc pl-4"] do
      tmux_nix language
      monorepo language
      brack language
      portfolio language
      wascaml language
      sohosai language
      mock_up language
      ffmpeg_nim language
      piledit language
      unit_lib language
      mifton language

software_li :: forall m. String -> Boolean -> Component m -> Component m
software_li name archived comp = do
  JE.li ["class" := "mt-1"] do
    JE.details [] do
      JE.summary ["class" := "cursor-pointer select-none list-none"] do
        text name
        JE.span ["class" := "ml-2 text-slate-400 text-sm"] do
          if archived then
            text "Archived"
          else text ""
      comp

monorepo :: forall m. Language -> Component m
monorepo language = do
  software_li (s language "monorepo (2023/04 - present)" "monorepo (2023/04 - 現在)") false do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        tx language "Nix and others" "Nix, その他"
      JE.li [] do
        tx language "A collection of software and configuration I develop" "開発しているソフトウェア群・設定集"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/momeemt/monorepo" do
          text "momeemt/monorepo"

tmux_nix :: forall m. Language -> Component m
tmux_nix language = do
  software_li (s language "tmux-nix (2025/05 - present)" "tmux-nix (2025/05 - 現在)") false do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "Nix, tmux"
      JE.li [] do
        tx language "A NixOS module for configuring tmux without tmux.conf" "tmux.confレスに設定を行うためのNixOSモジュール"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/momeemt/tmux-nix" do
          text "momeemt/tmux-nix"

wascaml :: forall m. Language -> Component m
wascaml language = do
  software_li "wascaml (2024/05 - 08)" false do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "OCaml, WebAssembly, Python"
      JE.li [] do
        tx language
          "An OCaml-subset compiler targeting WebAssembly. It includes a performance sanitizer (PSan) that detects inefficient linked-list operations."
          "WebAssemblyターゲットのOCamlサブセットコンパイラ。Linked Listに対する非効率な操作を検出するパフォーマンスサニタイザ(PSan)を実装している。"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/momeemt/wascaml" do
          text "momeemt/wascaml"

portfolio :: forall m. Language -> Component m
portfolio language = do
  software_li "momee.mt (2024/08)" false do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "PureScript, Jelly 🍮, Tailwind"
      JE.li [] do
        tx language "This portfolio website" "このポートフォリオWebサイト"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/momeemt/monorepo/tree/develop/packages/p/portfolio" do
          text "momeemt/monorepo/packages/p/portfolio"

brack :: forall m. Language -> Component m
brack language = do
  software_li "Brack (2022/08 - 2025/06)" false do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "Rust, WebAssembly"
      JE.li [] do
        tx language "A bracket-based lightweight markup language whose transformation rules can be extended with WebAssembly" "WebAssemblyで変換規則を拡張可能な括弧ベースの軽量マークアップ言語"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/brack-lang/brack" do
          text "brack-lang/brack"
        text " w/"
        external_link "https://github.com/uekann" do
          text "@uekann"

sohosai :: forall m. Language -> Component m
sohosai language = do
  software_li "Sohosai (2022/06 - 2023/10)" true do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "Rust, Nix, Terraform, Sakura Cloud, Auth0, Roundcube"
      JE.li [] do
        tx language "Feature development and operation for an event-management app, plus mail-system development" "企画管理アプリケーションの機能開発・運用やメールシステムの開発"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/sohosai" do
          text "sohosai"
        text " w/"
        external_link "https://github.com/raspi0124" do
          text "@raspi0124"
        text ", "
        external_link "https://github.com/puripuri2100" do
          text "@puripuri2100"
        text ", et al."

mock_up :: forall m. Language -> Component m
mock_up language = do
  software_li "mock up (2021/03 - 2022/12)" true do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "Nim, FFmpeg, OpenGL, HLS, nginx"
      JE.li [] do
        tx language "A video-editing framework that renders edits described in YAML" "YAMLで編集内容を記述してレンダリングを行う動画編集フレームワーク"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/mock-up/mock-up" do
          text "mock-up/mock-up"

ffmpeg_nim :: forall m. Language -> Component m
ffmpeg_nim language = do
  software_li "ffmpeg.nim (2021)" false do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "Nim, FFmpeg"
      JE.li [] do
        tx language "A Nim wrapper for FFmpeg" "FFmpegのNim言語ラッパー"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/momeemt/ffmpeg.nim" do
          text "momeemt/ffmpeg.nim"

piledit :: forall m. Language -> Component m
piledit language = do
  software_li "Piledit (2020 - 2021)" true do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "TypeScript, Vue, Electron, C#, FFmpeg"
      JE.li [] do
        tx language "Video-editing software built around visual blocks" "ビジュアルブロックを利用して編集する動画編集ソフトウェア"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/motionline/piledit-frontend" do
          text "motionline/piledit-frontend"
        text " w/"
        external_link "https://github.com/kuro1215" do
          text "@kuro1215"

unit_lib :: forall m. Language -> Component m
unit_lib language = do
  software_li "Unit (2020)" false do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "Nim"
      JE.li [] do
        tx language "A Nim library for manipulating SI units at the type level" "国際単位系(SI)を型レベルで操作できるNimライブラリ"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/momeemt/unit" do
          text "momeemt/unit"

mifton :: forall m. Language -> Component m
mifton language = do
  software_li "Mifton (2019)" true do
    JE.ul ["class" := "list-disc pl-4"] do
      JE.li [] do
        text "Ruby, Ruby on Rails"
      JE.li [] do
        tx language "A social network for Minecraft Bedrock Edition users" "Minecraft統合版ユーザを対象にしたSNS"
      JE.li [] do
        text "GitHub: "
        external_link "https://github.com/momeemt/mifton" do
          text "momeemt/mifton"
