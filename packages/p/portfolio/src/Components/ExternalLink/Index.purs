module ExternalLink where

import Jelly.Element as JE
import Jelly.Component (Component)
import Jelly.Prop ((:=))

external_link :: forall m. String -> Component m -> Component m
external_link href children = do
  JE.a ["class" := "leading-loose pb-px border-b", "href" := href, "target" := "_blank", "rel" := "noopener noreferrer"] do
    children
