import entity 
from illwill import Key

var
  w* = initWorld(30, 30)
  player* = Ship(hull: 10)
  other = Ship(hull: 5)

w.ships[0, 0] = player
w.ships[0, 1] = other

proc playerAction*(key: Key) =
  case key
  of H: w.ships[w.ships[player].x-1, w.ships[player].y] = player
  else: discard
