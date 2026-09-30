module Writing where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import Language (Language, s, tx)


writing_li :: forall m. String -> Component m -> Component m
writing_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

writing :: forall m. Language -> Component m
writing language = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    tx language "Writing" "執筆活動"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    writing_li (s language "WORD Admission Celebration Issue 2024 (2024/04)" "WORD 入学祝い号2024 (2024/04)") do
      JE.li' do
        tx language "\"Fever\"" "『発熱』"
      JE.li' do
        external_link "https://www.word-ac.net/post/2024/0409-iwai2024/" do
          tx language "Download PDF" "PDF版のダウンロード"
    writing_li (s language "WORD Issue 54 (2023/12)" "WORD 54号 (2023/12)") do
      JE.li' do
        tx language "\"Mail Battle 2023\" w/" "『メールバトル2023』 w/"
        external_link "https://github.com/raspi0124" do
          text "@raspi0124"
      JE.li' do
        external_link "https://www.word-ac.net/post/2023/1225-word54/" do
          tx language "Download PDF" "PDF版のダウンロード"
    writing_li (s language "University of Tsukuba College of Information Science 2023 welcome pamphlet (2023/04)" "2023年度 筑波大学情報科学類 新歓パンフレット (2023/04)") do
      JE.li' do
        tx language "\"Announcements and Upcoming Schedule\", \"Course Registration\", typesetting, and more" "『連絡事項・今後の予定』、『履修について』、組版など"
      JE.li' do
        text "w/"
        external_link "https://github.com/puripuri2100" do
          text "@puripuri2100"
        text ", "
        external_link "https://github.com/uekann" do
          text "@uekann"
        text ", et al."
    writing_li (s language "WORD Moving Preparation Issue 2023 (2023/03)" "WORD 引越し準備号2023 (2023/03)") do
      JE.li' do
        tx language "\"Apartment Life\"" "『アパート暮らし』"
    writing_li (s language "Metaprogramming Nim (2022/09)" "メタプログラミングNim (2022/09)") do
      JE.li' do
        tx language "A technical doujin book focused on metaprogramming in Nim" "Nim言語のメタプログラミングに焦点を当てた技術同人誌"
      JE.li'  do
        tx language "First sold at: " "初出イベント: "
        external_link "https://techbookfest.org/product/9MmhQfKjFRcRUFChKUqDLM" do
          tx language "Technical Book Fair 13" "技術書典13" 
    writing_li (s language "Programming Nim (2021/08)" "プログラミングNim (2021/08)") do
      JE.li' do
        tx language "A Japanese-language guidebook for Nim, a systems programming language" "システムプログラミング言語であるNimの日本語解説書"
      JE.li' do
        tx language "Publisher: Impress Corporation" "発行: 株式会社インプレス"
      JE.li' do
        external_link "https://nextpublishing.jp/book/13584.html" do
          tx language "Book website" "本書のWebサイト"
