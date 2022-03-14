import tables, hashes

type
  Direction* = enum
    N, NE, E, SE, S, SW, W, NW

  Entity = ref object of RootObj

  Ship* = ref object of Entity
    hull*, supplies*: int
    facing*: Direction
    dx*, dy*: int

  Land* = ref object of Entity

  Coord* = tuple
    x, y: int

  # Layer of the map
  Layer[T] = object
    # Width, Height
    w, h: Positive
    entities: Table[Coord, T]
    positions: Table[T, Coord]

  World* = object
    w*, h*: Positive
    ships*: Layer[Ship]
    lands*: Layer[Land]

proc left*(dir: Direction): Direction = 
  result = if dir == N: NW else: pred(dir)

proc right*(dir: Direction): Direction = 
  result = if dir == NW: N else: succ(dir)

proc turnLeft*(dir: var Direction) =
  dir = left(dir)

proc turnRight*(dir: var Direction) =
  dir = right(dir)

proc initLayer[T](w, h: Positive): Layer[T] =
  result = Layer[T](w: w, h: h,
                    entities: initTable[Coord, T](),
                    positions: initTable[T, Coord]())

proc initWorld*(w, h: Positive): World =
  result = World(w: w, h: h, ships: initLayer[Ship](w, h),
                             lands: initLayer[Land](w, h))

proc hash*(entity: Entity): Hash =
  result = cast[Hash](entity)

proc contains*(l: Layer, key: Coord): bool =
  result = key in l.entities

proc contains*[T](l: Layer, key: T): bool =
  result = key in l.positions

# Least positive residue, aka modulo but always positive, as with number theory
# Simlulates counting in a circle (counting up or down to a number, but
# looping around when hitting the divisor, or negatives)
proc lpr(dividend: int, divisor: Positive): int =
  result = if dividend >= 0: dividend mod divisor
           else: (dividend mod divisor) + divisor

# North is used as downwind, South is upwind
proc relativeWindDir*(wind, ship: Direction): Direction =
  result = Direction(lpr(ord(wind) - ord(ship), 8))

# Makes the map loop around in both axis
# Loop around with coordinates that would otherwise be OOB
proc normalize*(l: Layer, coord: Coord): Coord =
  result = (x: lpr(coord.x, l.w), y: lpr(coord.y, l.h))

proc normalize*(l: Layer, x, y: int): Coord =
  result = l.normalize((x, y))

proc `[]`*[T](l: Layer[T], coord: Coord): T =
  # Loop around with coordinates that would otherwise be OOB
  result = l.entities[l.normalize(coord)]

proc `[]`*[T](l: Layer[T], x, y: int): T =
  result = l.entities[(x: x, y: y)]

proc `[]`*[T](l: Layer[T], entity: T): Coord =
  result = l.positions[entity]

proc `[]=`*[T](l: var Layer[T], coord: Coord, entity: T) =
  # Clear original position
  if entity in l.positions:
    l.entities.del(l.positions[entity])
  # Loop around with coordinates that would otherwise be OOB (as above)
  l.entities[l.normalize(coord)] = entity
  l.positions[entity] = l.normalize(coord)

proc `[]=`*[T](l: var Layer[T], x, y: int, entity: T) =
  l[(x: x, y: y)] = entity

proc move*(w: var World, s: Ship, dist: int) =
  let
    (x, y) = case s.facing
    of N: (0, -1)
    of NE: (1, -1)
    of E: (1, 0)
    of SE: (1, 1)
    of S: (0, 1)
    of SW: (-1, 1)
    of W: (-1, 0)
    of NW: (-1, -1)
    coord = w.ships[s]
  for i in 0..<dist:
    if (coord.x + x, coord.y + y) in w.lands:
      s.hull -= 1
    else:
      w.ships[coord.x + x, coord.y + y] = s
      s.dx += x
      s.dy += y

when isMainModule:
  var
    test = initLayer[Entity](20, 30)
    entity = Entity()
  test[20, 30] = entity
  echo test[entity]
  echo (x: 0, y: 0) in test.entities
  test[30, -20] = entity
  echo test[entity] # 10, 10
  echo (x: 0, y: 0) in test.entities

  var
    w = initWorld(21, 21)
    player = Ship(hull: 20)
  w.ships[0, 0] = player
  echo w.ships[player]
