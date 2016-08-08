{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

import Application

import Control.Applicative
import Snap.Snaplet
import Snap.Snaplet.Heist.Compiled
import Snap.Util.FileServe
import Heist
import Control.Lens

app :: Example -> SnapletInit App App
app ex = makeSnaplet "tutorial" "Heist tutorial" Nothing $ do
  h <- nestSnaplet "" heist $ heistInit' (examplePath ex) emptyHeistConfig
  addConfig h $ mempty & scCompiledSplices .~ (exampleSplices ex)
  wrapSite (<|> heistServe)
  return $ App h
