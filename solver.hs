module Solver (solve_level,
  -- Tube, Tube(..), Move, Move(..), Colour,
  ) where

import Data.List
import Levels

-- Tubes consist of a tube number, counting from 1, and a list of colours
data Tube = Tube Int [Colour] deriving (Show)
instance Eq Tube
  where (==) (Tube t1 _) (Tube t2 _) = t1 == t2

-- A game state is a list of all the tubes at a given time
type State = [Tube]

-- A move consists of two tubes, the first From and the other To
data Move = Move Tube Tube deriving Eq

instance Show Move
  where show (Move (Tube fn _) (Tube tn _)) = show (fn, tn)

-- Load a level number, verify it, and solve it
solve_level :: Int -> [Move]
solve_level n = let
  l = level n
  sts = level_to_state l
  (state, moves) = solve_state (sts, [])
  in
  if (verify_level l) then
    reverse moves
  else
    error "Invalid Level Data"

-- Given a state and a set of moves, find a winning state and the set of further
-- moves needed to reach it
solve_state :: (State, [Move]) -> (State, [Move])
solve_state (state, past) = let

  -- Get the possible moves and corresponding states for every state directly reachable
  -- from this one
  moves = find_valid_moves state
  results = map (move_result state) moves

  -- List of the result solve_state on each of the states reachable from this one
  -- ie all of the states reachable within 2 steps of this one
  next_states = [solve_state(x, (move:past)) | (x, move) <- zip results moves]

  -- Finds the first winning state among the states directly reachable from this one
  (win_in_this, move) = head $ filter (\x -> win_state $ fst x) (zip results moves)

  in
  -- If there is a win state directly reachable from this one, return it
  if any win_state results then
    (win_in_this, move:past)
  -- Otherwise check if there is a win state reachable 2 steps from this one
  -- (will recursively check as many steps as are possible)
  else if any (\x -> win_state $ fst x) next_states then
    head $ filter (\x -> win_state $ fst x) next_states

  -- Otherwise, if no winning states are reachable from here, return empty list
  else ([], past)

-- Given a game state, find all legal moves
find_valid_moves :: State -> [Move]
find_valid_moves state = let
  -- all combinations of tubes that could be a move
  all_moves = [Move x y | x <- state, y <- state, x /= y]

  -- Filter to determine legal moves
  move_filter (Move (Tube _ fc) (Tube _ tc)) = let
    capacity = 4 - (length tc)
    contiguous = length (takeWhile (== head fc) fc)
    in
    -- The from tube cannot be empty, the to tube cannot be full,
    -- and the to tube must be empty or match the top of the from tube
    fc /= [] && length tc < 4 && ((tc == []) || head fc == head tc) &&
      -- To tube being empty implies the from tube is not all the same colour,
      -- as pouring a same tube into empty is pointless and leads to infinite loops
      (tc /= [] || not (all_same fc)) &&
      -- Prevent pouring when there's not enough room (legal, but leads to infinite loops)
      capacity >= contiguous

  in filter move_filter all_moves

-- Given a state and a move, finds the new state after applying that move
move_result :: State -> Move -> State
move_result state (Move ft@(Tube fn fc) tt@(Tube tn tc)) = let
  capacity = 4
  to_capacity = capacity - (length (tc))
  first_from = head fc
  first_to = head tc
  max_pour = take to_capacity fc
  pour = takeWhile (==first_from) max_pour
  size = length pour
  fc_new = drop size fc
  tc_new = pour ++ tc

  -- New state is the old state with the tubes in Move replaced with new ones
  in (Tube fn fc_new : Tube tn tc_new : (state \\ [ft, tt]))

-- Determines if a state is a victorious one
win_state :: State -> Bool
win_state state =
  -- The state must be non-empty, and must contain only tubes that are empty or
  -- are entirely full of the same colour
  state /= [] &&
  (and $ map (\x -> tube_list x == [] || (all_same (tube_list x) && (length $ tube_list x) == 4)) state)

-- Extracts the colour list from a tube
tube_list :: Tube -> [Colour]
tube_list (Tube _ tc) = tc

-- Checks every element in a list is the same
all_same :: Eq a => [a] -> Bool
all_same xs = and $ map (== head xs) (tail xs)

-- Takes level data and converts it to the initial state
level_to_state :: Level -> State
level_to_state l = let
  len = length l
  in zipWith (\x y -> Tube x y) [1..len] l

-- Checks the level has 4 of each colour
verify_level :: Level -> Bool
verify_level l = let
  flat = concat l
  sames = group (sort flat)
  in and $ map (\x -> length x == 4) sames
