module Tutorial.Examples
       ( examplesMap
       , launchExample
       , example1
       , example2
       ) where

{-
If you are looking for the example sources, look for the numbered
Example files.
-}

import Tutorial.Example1
import Tutorial.Example2
import Site

import Snap.Snaplet
import Snap.Http.Server.Config
import Data.Map.Syntax
import Data.Map.Lazy
import Application

allExamples :: [Example]
allExamples =
  [ example1Data
  , example2Data
  ]

launchExample :: Example -> IO ()
launchExample ex = serveSnaplet defaultConfig (app ex)

examplesMap :: Map String Example
examplesMap = either (const empty) id $ runMap $
              mapM (\ex -> (examplePath ex) ## ex) allExamples

example1 :: IO ()
example1 = launchExample example1Data

example2 :: IO ()
example2 = launchExample example2Data
