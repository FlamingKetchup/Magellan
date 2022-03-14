import illwill, entity

const visRange = 10
var tb = newTerminalBuffer(2*visRange + 1, 2*visRange + 1)

proc initGraphics*() =
  illwillInit()
  hideCursor()

proc drawWorld*(w: World, player: Ship) =
  let (playerX, playerY) = w.ships[player]
  for x in playerX-visRange ..< playerX+visRange+1:
    for y in playerY-visRange ..< playerY+visRange+1:
      var
        coord = w.ships.normalize(x, y)
        relCoord = w.ships.normalize(coord.x - playerX + 10,
                                     coord.y - playerY + 10)
      if not(coord in w.lands):
        tb.write(relCoord.x, relCoord.y, fgBlue, "≈", resetStyle)
      else:
        tb.write(relCoord.x, relCoord.y, fgGreen, "#", resetStyle)
      if coord in w.ships:
        tb.write(relCoord.x, relCoord.y, "S")
  tb.write(10, 10, "@")

proc display*() =
  tb.display()
  tb.clear()
