module Main where
import Solver
import System.Environment


main :: IO()
main = do
  args <- getArgs
  case args of
    [str] -> let int = read str in
      print (solve_level int)
    _  -> putStrLn ("Invalid Argument")
