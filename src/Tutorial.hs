module Tutorial where

import Tutorial.Examples

import Data.Maybe
import Data.Map.Lazy
import System.Environment
import Prelude hiding (lookup)

{-
You shouldn't most likely set up a Snap application like this tutorial
does it.  Use snap init.  The examples in the Tutorial directory are
meant to look like parts of real programs.
-}

{-
Run main to parse the command line argument or directly use cabal
repl.
-}
main :: IO ()
main = do
  arg <- listToMaybe <$> getArgs
  case arg of
   Nothing -> print "usage: tutorial <example>"
   Just exPath -> do
     let ex = lookup exPath examplesMap
     case ex of
      Nothing -> print "no such example"
      Just ex' -> launchExample ex'
