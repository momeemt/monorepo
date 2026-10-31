module WorkExperience where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import Language (Language, s, tx)

work_experience_li :: forall m. String -> Component m -> Component m
work_experience_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

work_experience :: forall m. Language -> Component m
work_experience language = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    tx language "Work Experience" "就労経験"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    work_experience_li (s language "GA technologies Co., Ltd. Internship (2026/04 - present)" "株式会社GA technologies インターンシップ (2026/04 - 現在)") do
      JE.li' do
        tx language "Platform engineer" "プラットフォームエンジニア"
    work_experience_li (s language "Sony Interactive Entertainment Inc. Internship (2026/02)" "株式会社ソニー・インタラクティブエンタテインメント インターンシップ (2026/02)") do
      JE.li' do
        tx language "Build-system engineer" "ビルドシステムエンジニア"
    work_experience_li (s language "LY Corporation Internship (2024/09)" "LINEヤフー株式会社 インターンシップ (2024/09)") do
      JE.li'  do
        tx language "Infrastructure engineer" "インフラエンジニア"
      JE.li' do
        external_link "https://www.lycorp.co.jp/ja/recruit/landingpage/INFRA-02-02/" do
          tx language "Developed FractalDB, an in-house distributed database system" "内製分散データベースシステム FractalDB の開発業務"
    work_experience_li (s language "pixiv Inc. Internship (2022/09)" "ピクシブ株式会社 インターンシップ (2022/09)") do
      JE.li' do
        tx language "Image-delivery engineer" "画像配信エンジニア"
      JE.li' do
        tx language "Worked on speeding up GIF image delivery in ImageFlux" "ImageFluxにおけるGIF画像の配信を高速化する業務に従事"
      JE.li' do
        tx language "Internship report: " "参加記: "
        external_link "https://zenn.dev/momeemt/articles/pixiv-summer-boot-camp-2022" do
          tx language "Made animation encoding 12x faster than GIFs during a pixiv internship" "ピクシブのインターンに参加してアニメーションのエンコードをGIFから12倍高速にした"
    work_experience_li (s language "Invast Inc. Internship (2022/01 - 08)" "インヴァスト株式会社 インターンシップ (2022/01 - 08)") do
      JE.li' do
        tx language "Frontend engineer" "フロントエンドエンジニア"
      JE.li' do
        tx language "Worked on frontend development for an in-house application" "内製アプリケーションのフロントエンド開発に従事"
