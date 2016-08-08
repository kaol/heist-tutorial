{-# LANGUAGE OverloadedStrings #-}

module Tutorial.Example1 (example1Data) where

import Application(AppHandler, Example, Example(..))

import Heist.Compiled
import Data.Map.Syntax
import Data.Text (pack, unpack)
import Heist
import Text.XmlHtml
import Control.Monad (guard)

example1Data :: Example
example1Data = Example "example1" mainSplices

-- Top level splices definition
mainSplices :: Splices (Splice AppHandler)
mainSplices = do
  "repeat" ## repeatImpl
  -- A simple splice that just outputs text
  "hello" ## return $ yieldPureText "Hello world"

repeatImpl :: Splice AppHandler
repeatImpl = do
  -- Get the attribute value from the template.  Note that this throws
  -- an error at load time if times' value is something besides a
  -- positive integer.  It's not type safety as such but you'll still
  -- get the errors at program start instead of later on.
  times <- maybe 1 (read . unpack) . getAttribute "times" <$> getParamNode
  guard $ times >= 1

  -- This generates a splice from the child elements of <h:repeat/>
  spl <- runChildren

  -- Multiply the hello message.
  return $ mconcat $ replicate times spl
