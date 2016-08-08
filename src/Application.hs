{-# LANGUAGE TemplateHaskell #-}
module Application where

import Control.Lens
import Heist
import Snap.Snaplet.Heist
import Snap
import Heist.Compiled

data App = App
  { _heist :: Snaplet (Heist App)
  }

makeLenses ''App

instance HasHeist App where
  heistLens = subSnaplet heist

type AppHandler = Handler App App

data Example = Example
  { examplePath :: FilePath
  , exampleSplices :: Splices (Splice (AppHandler))
  }
