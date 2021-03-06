module Modules.Hearthstone
  ( respondToCardSearchQuery
  )
  where

import HearthstoneAPI.Requests (searchCards)
import HearthstoneAPI.Types    (Card(..))

import           BotAPI.Requests     (answerInlineQuery)
import           BotAPI.Types.Inline (InlineQueryResult(..))
import           Data.Maybe          (mapMaybe)
import           Data.Text           (Text)
import qualified Data.Text           as T (drop, dropWhile, isPrefixOf)

respondToCardSearchQuery :: Text -> Text -> IO ()
respondToCardSearchQuery queryId queryText = do
  cards <- searchCards $ cleanQuery queryText
  answerInlineQuery queryId (take 50 $ (if isGoldQuery queryText then cardsToGoldResults else cardsToNormalResults) cards)

cardsToNormalResults :: [Card] -> [InlineQueryResult]
cardsToNormalResults = mapMaybe toResult
  where
    toResult (Card cId _ _ (Just imageUrl) _) = Just (InlineQueryResult "photo" cId (Just imageUrl) Nothing imageUrl)
    toResult _ = Nothing

cardsToGoldResults :: [Card] -> [InlineQueryResult]
cardsToGoldResults = mapMaybe toResult
  where
    toResult (Card cId _ _ _ (Just goldUrl)) = Just (InlineQueryResult "gif" cId Nothing (Just goldUrl) goldUrl)
    toResult _ = Nothing

isGoldQuery :: Text -> Bool
isGoldQuery q = ("g " `T.isPrefixOf` q)

cleanQuery :: Text -> Text
cleanQuery = T.dropWhile (== ' ') . (\q -> if (isGoldQuery q)
                                            then (T.drop 2 q)
                                            else q)
