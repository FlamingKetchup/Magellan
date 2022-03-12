import game, graphics
from illwill import getKey


initGraphics()

while true:
  playerAction(getKey())
  drawWorld(w, player)
  display()
