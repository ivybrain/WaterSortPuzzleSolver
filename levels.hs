module Levels (level, Colour, Level) where

-- Colours as I see them. Can add more or change if needed.
data Colour = Violet | Red | Orange | Blue | Green | Lightgreen | Pink |
  Purple | Grey | Olive | Yellow | Brown
  deriving (Eq, Show, Ord)

-- Levels are lists of tubes, which are in turn lists of colours.
-- Colours in tubes are listed top to bottom. Empty tubes in the level are denoted by []
type Level = [[Colour]]

level :: Int -> Level
level 0 = [
  [Violet, Red, Orange, Violet],
  [Violet, Red, Orange, Orange],
  [Red, Orange, Violet, Red],
  [],
  []]

level 105 = [
  [ Violet, Green, Blue, Blue],
  [ Purple, Pink, Olive, Grey],
  [ Orange, Purple, Red, Brown],
  [ Orange, Pink, Red, Orange],
  [ Green, Red, Yellow, Violet],
  [ Yellow, Green, Brown, Green],
  [ Brown, Purple, Red, Lightgreen],
  [ Lightgreen, Purple, Pink, Lightgreen],
  [ Olive, Grey, Blue, Violet],
  [ Brown, Yellow, Grey, Olive],
  [ Grey, Yellow, Lightgreen, Violet],
  [ Olive, Blue, Pink, Orange],
  [],
  []]

level 108 = [
  [Blue, Green, Red, Lightgreen],
  [Blue, Blue, Green, Pink],
  [Red, Red, Green, Purple],
  [Violet, Pink, Orange, Grey],
  [Pink, Red, Grey, Purple],
  [Lightgreen, Grey, Purple, Violet],
  [Orange, Purple, Green, Violet],
  [Orange, Grey, Orange, Lightgreen],
  [Pink, Lightgreen, Violet, Blue],
  [],
  []]

level 135 = [
  [ Red, Orange, Red, Pink],
  [ Purple, Violet, Pink, Grey],
  [ Yellow, Blue, Green, Brown],
  [ Yellow, Green, Green, Purple],
  [ Pink, Olive, Lightgreen, Red],
  [ Pink, Brown, Grey, Olive],
  [ Blue, Lightgreen, Yellow, Lightgreen],
  [ Violet, Red, Orange, Olive],
  [ Blue, Brown, Yellow, Green],
  [ Orange, Orange, Grey, Blue],
  [ Grey, Brown, Purple, Purple],
  [ Violet, Lightgreen, Violet, Olive],
  [],
  []]
