module Qualification where

import Prelude

import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import Language (Language, s, tx)

qualification_li :: forall m. String -> Component m -> Component m
qualification_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

qualification :: forall m. Language -> Component m
qualification language = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    tx language "Certifications" "資格"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    qualification_li "TOEFL iBT 3.5 (2026/05)" do
      JE.li' do
        text "ETS"
    qualification_li (s language "Class 1 Ordinary Motor Vehicle Driver's License (2025/10)" "普通自動車第一種運転免許 (2025/10)") do
      JE.li' do
        tx language "Public Safety Commission" "公安委員会"
    qualification_li (s language "CG Engineer Certification, Expert (2023/12)" "CGエンジニア検定 エキスパート (2023/12)") do
      JE.li' do
        tx language "Computer Graphic Arts Society" "公益社団法人 画像情報教育振興協会"
    qualification_li (s language "Applied Information Technology Engineer Examination (2022/06)" "応用情報技術者 (2022/06)") do
      JE.li' do
        tx language "Information-technology Promotion Agency, Japan" "独立行政法人 情報処理推進機構"
    qualification_li (s language "Fundamental Information Technology Engineer Examination (2021/03)" "基本情報技術者 (2021/03)") do
      JE.li' do
        tx language "Information-technology Promotion Agency, Japan" "独立行政法人 情報処理推進機構"
