{-# LANGUAGE OverloadedStrings #-}

-- Compiled Heist doesn't come with the apply and apply-content
-- splices that interpreted Heist uses.  This example demonstrates how
-- you can make your own.

module Tutorial.Example4 (example4Data) where

import Application(AppHandler, Example, Example(..))

import Heist.Compiled
import Data.Map.Syntax
import Heist
import Heist.Compiled
import qualified Text.XmlHtml as X
import Data.Maybe
import Data.Text.Encoding (encodeUtf8)

example4Data :: Example
example4Data = Example "example4" mainSplices

-- Top level splices definition
mainSplices :: Splices (Splice AppHandler)
mainSplices = do
  "apply" ## applyImpl

applyImpl :: Splice AppHandler
applyImpl = do
  -- Get the template file name from the attribute in the current
  -- node.
  name <- encodeUtf8 . fromJust . X.getAttribute "template" <$> getParamNode
  -- Get the child nodes of the current node.
  cx <- X.childNodes <$> getParamNode
  -- Define our apply-content splice with the child nodes and call the
  -- named template.
  withLocalSplices ("apply-content" ## runNodeList cx)
    mempty $ callTemplate name
