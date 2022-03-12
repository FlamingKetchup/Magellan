import illwill, entity

var tb = newTerminalBuffer(21, 21)

proc initGraphics*() =
  illwillInit()
  hideCursor()

proc drawWorld*(w: World, player: Ship) =
  let (playerX, playerY) = w.ships[player]
  for x in playerX-10 ..< playerX+11:
    for y in playerY-10 ..< playerY+11:
      var coord = w.ships.normalize((x, y))
      if coord in w.ships:
        var (shipX, shipY) = w.ships.normalize((coord.x - playerX + 10,
                                                coord.y - playerY + 10))
        tb.write(shipX, shipY, "S")
  tb.write(10, 10, "@")

proc display*() =
  tb.display()
  tb.clear()
