module Educational where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import Language (Language, s, tx)

educational_li :: forall m. String -> Component m -> Component m
educational_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

educational :: forall m. Language -> Component m
educational language = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    tx language "Education" "学歴"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    educational_li (s language "College of Information Science, University of Tsukuba (2022/04 - 2026/03)" "筑波大学情報学群情報科学類 (2022/04 - 2026/03)") do
      JE.li' do
        tx language "Software Science major (2024/04 - 2026/03)" "ソフトウェアサイエンス主専攻 (2024/04 - 2026/03)"
      JE.li' do
        external_link "https://syssec.cs.tsukuba.ac.jp/wp/" do
          tx language "System Security Laboratory (2025/04 - 2026/03)" "システムセキュリティ研究室 所属 (2025/04 - 2026/03)"
      JE.li' do
        tx language "GPA: 3.88 / 4.3 (172 credits)" "成績: 3.88 / 4.3 (172単位修得)"
      JE.li' do
        external_link "https://www.coins.tsukuba.ac.jp/award/" do
          tx language "Dean's Award, School of Informatics" "情報学群長賞"
        tx language " recipient" " 受賞"
    educational_li (s language "Tokyo Metropolitan Oushukan Secondary Education School (2016/04 - 2022/03)" "都立桜修館中等教育学校 (2016/04 - 2022/03)") do
      JE.li' do
        tx language "11th cohort" "11期"
