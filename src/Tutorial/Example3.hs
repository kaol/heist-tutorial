{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

-- This example shows various ways to handle attributes.
module Tutorial.Example3 (example3Data, optionAttrSplices) where

import Application(AppHandler, Example, Example(Example), appData)

import Data.Monoid
import Heist.Compiled
import Data.Map.Syntax
import Data.Text (Text, append, pack)
import Heist
import Network.HTTP.Types.URI (Query, renderQuery, encodePath)
import Data.Text.Encoding (decodeLatin1)
import Blaze.ByteString.Builder (Builder)
import Blaze.ByteString.Builder.Char.Utf8 (fromString)
import Snap.Snaplet
import Control.Monad.Trans.Class
import Control.Lens (view)
import System.IO
import Control.Exception (bracket)
import Control.Monad.Trans

example3Data :: Example
example3Data = Example "example3" mainSplices

-- Top level splices definition
mainSplices :: Splices (Splice AppHandler)
mainSplices = do
  -- Workaround for a bug in Heist 1.0
  "relax" ## return $ yieldPure mempty
  -- Simple as it gets
  "simple" ## return $ yieldPureText "hello"
  -- URL escaping for a path and query, combined
  "href" ## return $ yieldPure $ (fromString "http://example.com") <> examplePathBuilder
  -- Another example of the same, this time only encoding the query part
  "href2" ## return $ yieldPureText $ "http://example.com/" `append` exampleQueryText
  -- Attribute splice, using data from application state
  "attrsplice" ## attrSpliceExample
  -- Attribute splice, using runtime data
  "attrspliceruntime" ## attrSpliceRuntimeExample

-- If you know that you need only to encode the query parameters
exampleQueryText :: Text
exampleQueryText = decodeLatin1 $ renderQuery True exampleQuery

-- Encode query parameters and the path.
examplePathBuilder :: Builder
examplePathBuilder = encodePath examplePath exampleQuery

examplePath :: [Text]
examplePath = [""]

exampleQuery :: Query
exampleQuery =
  [ ("simple", Just "foo")
  , ("escapes", Just "äö")
  , ("novalue", Nothing)
  ]

-- Example of using attribute splices with state from Application
-- state.  This could equivalently use some other snaplet to get the
-- data.
attrSpliceExample :: Splice AppHandler
attrSpliceExample = withLocalSplices mempty optionAttrSplices runChildren

optionAttrSplices :: Splices (AttrSplice AppHandler)
optionAttrSplices =
  "maybeselected" ## \v -> do
    preferred <- lift $ view appData
    let selected = if v == preferred
                   then [("selected", "")]
                   else []
    return $ ("value", v) : selected

-- This example passes the state to use in comparison from runtime
-- data.
preferredColorAction :: RuntimeSplice AppHandler Text
preferredColorAction = liftIO $ bracket (openFile "data/color" ReadMode)
                       hClose $ \handle -> pack . read <$> hGetLine handle

attrSpliceRuntimeExample :: Splice AppHandler
attrSpliceRuntimeExample = do
  let contentAction = preferredColorAction
  deferMap return (\runtimeAction -> withLocalSplices mempty
                                     (optionAttrRuntimeSplices runtimeAction)
                                     runChildren) contentAction

optionAttrRuntimeSplices :: RuntimeSplice AppHandler Text
                         -> Splices (AttrSplice AppHandler)
optionAttrRuntimeSplices runtimeAction =
  "maybeselected" ## \v -> do
    preferred <- runtimeAction
    let selected = if v == preferred
                   then [("selected", "")]
                   else []
    return $ ("value", v) : selected
