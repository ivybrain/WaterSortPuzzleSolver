# WaterSortPuzzleSolver
A program to solve levels of the mobile game Water Sort Puzzle.

I rewrote this in Haskell and its way faster on some of the more obstinate levels.

Currently levels are defined in the levels.hs file, and the program has to be recompiled
whenever a new one is added. I'll probably add the ability to read one from stdin later.

To compile:

`ghc -O4 watersort.hs`

To run:

`./watersort n`, where n is the level number of a level defined in levels.hs.

This outputs a list of moves (from, to), indicating which tube to pour into which.



Old version written in SWI-Prolog.

To run:

- Run swipl, load the files with
      `[watersort], [levels].`
- Run on a level from the levels file with
      `solve_puzzle(level, Moves).`
  Where level is a level number, which must be defined in the levels file.


Additional levels can be added as facts in the levels.pl file.
