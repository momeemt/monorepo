module Volunteer where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import Language (Language, s, tx)

volunteer_li :: forall m. String -> Component m -> Component m
volunteer_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

volunteer :: forall m. Language -> Component m
volunteer language = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    tx language "Volunteer Work" "ボランティア"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    volunteer_li (s language "Wakate no Kai for Information Science, organizer (2024/12 - present)" "情報科学若手の会 幹事 (2024/12 - 現在)") do
      JE.li' do
        external_link "https://wakate.org/" do
          tx language "Official website" "公式サイト"
    volunteer_li (s language "College of Information Science, University of Tsukuba Open Campus student staff (2022, 2025)" "筑波大学情報学群情報科学類 オープンキャンパス 学生スタッフ (2022, 2025)") do
      JE.li' do
        tx language "Program sessions and roundtable discussion (2025)" "企画セッション・座談会（2025）"
      JE.li' do
        tx language "Answered questions from prospective students (2022)" "受験生からの質疑応答（2022）"
    volunteer_li (s language "School Festival Executive Committee, Information Media Systems Bureau (2022/06 - 2023/10)" "学園祭実行委員会 情報メディアシステム局 (2022/06 - 2023/10)") do
      JE.li' do
        tx language "jsys22, jsys23 (network section lead)" "jsys22, jsys23(ネットワーク部門長)"
    volunteer_li (s language "College of Information Science New Student Welcome Committee (2022/12 - 2023/05)" "筑波大学情報学群情報科学類 新入生歓迎委員会 (2022/12 - 2023/05)") do
      JE.li' do
        tx language "Accounting, pamphlet typesetting, welcome-site development, and more" "会計、パンフレット組版、新歓Web開発など"
      JE.li' do
        text "GitHub: "
        external_link "https://github.com/hello-coins" do
          text "@hello-coins"
