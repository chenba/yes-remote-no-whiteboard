#!/usr/bin/env stack
-- stack script --resolver lts-9.4

{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.ByteString.Lazy.Char8 (unpack)
import Network.HTTP.Conduit (simpleHttp)
import Text.HandsomeSoup
import Text.XML.HXT.Core


remoteCompanies :: IO [String]
remoteCompanies = do
    html <- simpleHttp "https://github.com/remoteintech/remote-jobs/blob/master/README.md"
    let doc = readString [withParseHTML yes, withWarnings no] $ unpack html
    runX $ doc >>> css "tbody td:first-child" //> getText

main :: IO ()
main = do
    remoteCompanyNames <- remoteCompanies
    mapM_ putStrLn remoteCompanyNames
