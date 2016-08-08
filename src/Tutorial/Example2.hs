{-# LANGUAGE OverloadedStrings #-}

-- This example shows some operations on runtime data.
module Tutorial.Example2 (example2Data) where

import Application (Example, Example(..), AppHandler)

import Heist
import Heist.Compiled
import Data.Map.Syntax
import System.IO
import Control.Exception (bracket)
import Data.Text (pack, Text)
import Snap.Snaplet
import Control.Monad.Trans

example2Data :: Example
example2Data = Example "example2" mainSplices

-- A shopping list is a list of store, items list pairs
type ShoppingList = [(String,[String])]

-- Top level splices definition
mainSplices :: Splices (Splice AppHandler)
mainSplices = do
  "shopping" ## do
    -- Make a runtime action that loads the shopping list from a file.
    let contentsAction = shoppingListAction
    -- For each store in the shopping list, process the child nodes of
    -- <h:shopping/> and bind some more splices for that and pass
    -- along a runtime action that reads the shopping list.
    manyWithSplices runChildren shopSplices contentsAction

shoppingListAction :: RuntimeSplice AppHandler ShoppingList
shoppingListAction = liftIO $ bracket (openFile "data/shoppinglist" ReadMode)
                     hClose (\handle -> read <$> hGetLine handle)

-- Note how this is a map where the values are functions, not just
-- splices, in contrast to what the top level exampleSplices has.
shopSplices :: Splices (RuntimeSplice AppHandler (String,[String])
                        -> Splice AppHandler)
shopSplices = do
  -- The yieldRuntime family of functions construct chunks that make
  -- use of runtime values.  It allows getting access to the runtime
  -- value.
  "store" ## \runtimeAction ->
    return $ yieldRuntimeText $ pack . fst <$> runtimeAction
  "items" ##
    -- To process an item list for a store, we need to map the pair to
    -- the second value of the tuple.
    deferMap
    -- This turns the value into a RuntimeSplice AppHandler [String].
    (return . snd)
    -- Give each runtime String to a splice generating function
    (deferMany itemSplice)
    -- Pointfree style, deferMap gets the runtime as the third
    -- parameter.

-- Add a new splice "item" to the splice map which gets the String
-- from the runtime data and displays it.  Note that despite
-- manipulating the runtime data type in various ways, the splice's
-- position in the template remains the same.  Using runChildren here
-- still picks up the same children of the <h:items>.
itemSplice :: RuntimeSplice AppHandler String -> Splice AppHandler
itemSplice = withSplices runChildren ("item" ## pureSplice . textSplice $ pack)
