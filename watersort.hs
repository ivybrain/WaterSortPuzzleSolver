module Main where
import Solver
import System.IO (isEOF)



main :: IO()
main = do
  level <- read_level
  print $ solve_level level

read_level :: IO [[String]]
read_level = let
  go :: [[String]] -> IO [[String]]
  go contents = do
    done <- isEOF
    if done then
      return contents
    else do
      line <- getLine
      if line == "0" then
        go $ []:contents
      else
        go $ (words line):contents
  in go [] >>= (\x -> return (reverse x))
