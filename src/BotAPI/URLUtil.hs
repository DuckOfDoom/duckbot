module BotAPI.URLUtil where

import           System.Environment

readToken :: IO String
readToken = do
  mToken <- lookupEnv "BOT_TOKEN"
  maybe (putStrLn "Please assign token to 'BOT_TOKEN' environment variable!" >> return "BOT_TOKEN") return mToken

composeUrl :: String -> IO String
composeUrl url = do
  t <- readToken
  return ("https://api.telegram.org/bot" ++ t ++ "/" ++ url)

getMeUrl :: IO String
getMeUrl = composeUrl "getMe"

getUpdatesUrl :: IO String
getUpdatesUrl = composeUrl "getUpdates"

sendMessageUrl :: IO String
sendMessageUrl = composeUrl "sendMessage"

sendPhotoUrl :: IO String
sendPhotoUrl = composeUrl "sendPhoto"

answerInlineQueryUrl :: IO String
answerInlineQueryUrl = composeUrl "answerInlineQuery"