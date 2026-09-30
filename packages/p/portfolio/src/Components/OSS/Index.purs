module OSS where

import Prelude

import ExternalLink (external_link)
import Jelly.Component (Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import Language (Language, s, tx)

oss_li :: forall m. String -> Component m -> Component m
oss_li name comp = do
  JE.li ["class" := "mt-1"] do
    JE.details' do
      JE.summary ["class" := "list-none cursor-pointer select-none"] do
        text name
      JE.ul ["class" := "list-disc ml-4"] do
        comp

oss :: forall m. Language -> Component m
oss language = do
  JE.h2 ["class" := "text-2xl mt-4"] do
    tx language "Open Source" "OSS活動"
  JE.ul ["class" := "list-disc ml-4 mt-2"] do
    oss_li (s language "NixOS/nixpkgs (2024/05 - present)" "NixOS/nixpkgs (2024/05 - 現在)") do
      JE.li' do
        external_link "https://github.com/NixOS/nixpkgs/pulls?q=author%3Amomeemt+" do
          text "49 PRs merged"
      JE.li' do
        external_link "https://github.com/NixOS/nixpkgs/pulls?q=reviewed-by%3Amomeemt+-author%3Amomeemt" do
          text "302 PRs reviewed"
    oss_li "NixOS/nix (2025/01)" do
      JE.li' do
        external_link "https://github.com/NixOS/nix/pulls?q=author%3Amomeemt+" do
          text "1 PR merged"
