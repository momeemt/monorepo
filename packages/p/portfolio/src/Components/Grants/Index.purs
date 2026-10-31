module Grants where

import Prelude

import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import Language (Language, s, tx)

grants_li :: forall m. String -> Component m -> Component m
grants_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

grants :: forall m. Language -> Component m
grants language = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    tx language "Research Grants" "助成金"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    grants_li (s language "Undergraduate Research Experience Program (Type A), ¥78,508, University of Tsukuba (2023/05 - 2024/01)" "先導的研究者体験プログラム (種目A), ¥78,508, 筑波大学 (2023/05 - 2024/01)") do
      JE.li' do
        tx language "Developed an AR device and interface for paper books" "紙書籍に対するARデバイスの開発とインタフェースの実装"
    grants_li (s language "Undergraduate Research Experience Program (Type B), ¥90,000, University of Tsukuba (2022/05 - 2023/01)" "先導的研究者体験プログラム (種目B), ¥90,000, 筑波大学 (2022/05 - 2023/01)") do
      JE.li' do
        tx language "Applied saliency optimization to videos" "動画への顕著性最適化の適用"
