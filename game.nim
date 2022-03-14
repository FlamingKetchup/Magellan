import entity, worldgen, random
from illwill import Key

type
  Flow = tuple
    dir: Direction
    speed: int

  GameEndCode* = enum
    stillAlive, sunk, starved, won

var
  w* = generateWorld(300, 300)
  player* = Ship(hull: 10, supplies: 100, facing: W)
  wind*: Flow = (W, 1)
  startX = 0
  startY = 0

randomize()

while true:
  if (startX, startY) in w.lands:
    if startX < w.w:
      startX += 1
    else: 
      startY += 1
  else:
    w.ships[startX, startY] = player
    break

proc playerAction*(key: Key): GameEndCode =
  result = stillAlive # Player is not dead
  var tookAction = true
  case key
  of Q: player.facing.turnLeft()
  of Key.E: player.facing.turnRight()
  of Dot: discard
  else: tookAction = false
  
  if tookAction:
    case relativeWindDir(wind.dir, player.facing):
    of S: discard
    of SE, SW: w.move(player, wind.speed)
    of E, W: w.move(player, 3*wind.speed)
    of NE, NW: w.move(player, 2*wind.speed)
    of N: w.move(player, wind.speed)
    if player.supplies <= 0:
      return starved

    if player.hull <= 0:
      return sunk

    if abs(player.dx) >= w.w or abs(player.dy) >= w.h:
      return won

    player.supplies -= 1
  
    if rand(4) == 0:
      if rand(1) == 0:
        if wind.speed > 1:
          wind.speed -= 1
        else:
          wind.speed += 1

    if rand(19) == 0:
      if rand(1) == 0:
        wind.dir.turnLeft()
      else:
        wind.dir.turnRight()

