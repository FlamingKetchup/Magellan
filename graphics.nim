import illwill, entity

const visRange = 10
var tb = newTerminalBuffer(2*visRange + 30, 2*visRange + 1)

proc exitProc*(){.noconv.} =
  tb.resetAttributes()
  tb.display
  illwillDeinit()
  showCursor()
  quit(0)

setControlCHook(exitProc)
  
proc initGraphics*() =
  illwillInit()
  hideCursor()

proc drawWorld*(w: World, player: Ship, windSpeed: int, windDir: Direction) =
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
        tb.write(relCoord.x, relCoord.y, case w.ships[coord].facing
          of N: "^"
          of NE: "┐"
          of E: ">"
          of SE: "┘"
          of S: "v"
          of SW: "└"
          of W: "<"
          of NW: "┌")

  tb.write(2*visRange+2, 0, "Hull: " & $player.hull)
  tb.write(2*visRange+2, 1, "Supplies: " & $player.supplies)

  tb.write(2*visRange+2, 3, "Wind: " & $(windSpeed*2) & $ windDir)

proc loseScreenSunk*() =
  tb.write(0, 0, "You have run your ship aground")
  tb.write(0, 1, "Press Ctrl-C to quit")

proc loseScreenStarved*() =
  tb.write(0, 0, "You have starved, after running out of supplies")
  tb.write(0, 1, "Press Ctrl-C to quit")

proc winScreen*() =
  tb.write(0, 0, "Congratulations, you have successfully")
  tb.write(0, 1, "circumnavigated the globe")
  tb.write(0, 2, "Press Ctrl-C to quit")

proc display*() =
  tb.display()
  tb.clear()

