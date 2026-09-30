module Language where

import Prelude

import Effect (Effect)
import Jelly.Component (Component, text)

data Language = En | Ja

type Message =
  { en :: String
  , ja :: String
  }

foreign import currentPathname :: Effect String

currentLanguage :: Effect Language
currentLanguage = do
  pathname <- currentPathname
  pure $ if pathname == "/jp" || pathname == "/jp/" then Ja else En

s :: Language -> String -> String -> String
s En en _ = en
s Ja _ ja = ja

tx :: forall m. Language -> String -> String -> Component m
tx lang en ja = text $ s lang en ja

languageSwitchHref :: Language -> String
languageSwitchHref En = "/jp"
languageSwitchHref Ja = "/"

languageSwitchLabel :: Language -> String
languageSwitchLabel En = "日本語"
languageSwitchLabel Ja = "English"
