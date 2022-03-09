import tables, hashes

type
  Entity = ref object of RootObj

  Coord* = tuple
    x, y: int

  # Layer of the map
  Layer[T: Entity] = object
    # Height, Width
    w, h: int
    entities: Table[Coord, T]
    positions: Table[T, Coord]

proc initLayer[T](w, h: int): Layer[T] =
  result = Layer[T](w: w, h: h,
                    entities: initTable[Coord, T](),
                    positions: initTable[T, Coord]())

proc hash(entity: Entity): Hash =
  result = cast[Hash](entity)

# Least positive residue, aka modulo but always positive, as with number theory
# Simlulates counting in a circle (counting up or down to a number, but
# looping around when hitting the divisor, or negatives)
proc lpr(dividend: int, divisor: Positive): int =
  result = if dividend > 0: dividend mod divisor
           else: (dividend mod divisor) + divisor

# Makes the map loop around in both axis
# Loop around with coordinates that would otherwise be OOB
proc normalize(l: Layer, coord: Coord): Coord =
  result = (x: lpr(coord.x, l.w), y: lpr(coord.y, l.h))

proc `[]`[T](l: Layer[T], coord: Coord): T =
  # Loop around with coordinates that would otherwise be OOB
  result = l.entities[l.normalize(coord)]

proc `[]`[T](l: Layer[T], x, y: int): T =
  result = l.entities[(x: x, y: y)]

proc `[]`[T](l: Layer[T], entity: T): Coord =
  result = l.positions[entity]

proc `[]=`[T](l: var Layer[T], coord: Coord, entity: T) =
  # Clear original position
  if entity in l.positions:
    l.entities.del(l.positions[entity])
  # Loop around with coordinates that would otherwise be OOB (as above)
  l.entities[l.normalize(coord)] = entity
  l.positions[entity] = l.normalize(coord)

proc `[]=`[T](l: var Layer[T], x, y: int, entity: T) =
  l[(x: x, y: y)] = entity

when isMainModule:
  var
    test = initLayer[Entity](20, 30)
    entity = Entity()
  test[20, 30] = entity
  echo test[entity]
  echo (x: 0, y: 0) in test.entities
  test[30, -20] = entity
  echo test[entity]
  echo (x: 0, y: 0) in test.entities
