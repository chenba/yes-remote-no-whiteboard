#!/usr/bin/env stack
-- stack script --resolver lts-9.4

{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.ByteString.Lazy.UTF8 (toString)
import Network.HTTP.Conduit (simpleHttp)
import Text.HandsomeSoup
import Text.XML.HXT.Core

extractCompanyList :: String -> String -> IO [String]
extractCompanyList url selector = do
    html <- simpleHttp url
    let doc = readString [withParseHTML yes, withWarnings no] $ toString html
    runX $ doc >>> css selector //> getText

remoteCompanies :: IO [String]
remoteCompanies = extractCompanyList "https://github.com/remoteintech/remote-jobs/blob/master/README.md" "tbody td:first-child"

noWhiteboardCompanies :: IO [String]
noWhiteboardCompanies = extractCompanyList "https://github.com/poteto/hiring-without-whiteboards/blob/master/README.md" "article ul li a"

main :: IO ()
main = do
    remoteCompanyNames <- remoteCompanies
    mapM_ putStrLn remoteCompanyNames
