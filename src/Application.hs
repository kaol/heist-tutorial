{-# LANGUAGE TemplateHaskell #-}
module Application where

import Control.Lens
import Heist
import Snap.Snaplet.Heist
import Snap
import Heist.Compiled
import Data.Text (Text)

data App = App
  { _heist :: Snaplet (Heist App)
  , _appData :: Text
  }

makeLenses ''App

instance HasHeist App where
  heistLens = subSnaplet heist

type AppHandler = Handler App App

data Example = Example
  { examplePath :: FilePath
  , exampleSplices :: Splices (Splice (AppHandler))
  }
