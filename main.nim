import game, graphics
from illwill import getKey


initGraphics()

var cont = true
while cont:
  cont = false
  case playerAction(getKey())
  of starved: loseScreenStarved()
  of sunk: loseScreenSunk()
  of won: winScreen()
  of stillAlive:
    cont = true
    drawWorld(w, player, wind.speed, wind.dir)
  display()

while true:
  discard
