import entity, worldgen
from illwill import Key

type
  Flow = tuple
    dir: Direction
    speed: int

var
  w* = generateWorld(30, 30)
  player* = Ship(hull: 10, facing: W)
  other = Ship(hull: 5)
  wind: Flow

w.ships[0, 0] = player
w.ships[0, 1] = other

proc playerAction*(key: Key) =
  case key
  of H: w.ships[w.ships[player].x-1, w.ships[player].y] = player
  else: discard
