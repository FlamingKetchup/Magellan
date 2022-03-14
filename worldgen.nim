import random, math, entity
from sequtils import map

type
  NoiseParams = tuple
    amp: float
    freq: int

var frequencies = [(1.0, 1), (0.8, 2), (0.6, 4), (0.4, 8), (0.2, 16), (0.1, 32)]

proc singFreqNoise(freq, size: Positive): seq[float] =
  let phase = rand(TAU)
  for i in 0..<size:
    result &= (sin(TAU * (freq * i/size) + phase) + 1)/2

proc noise(params: openArray[NoiseParams], size: Positive): seq[float] =
  var
    totalWeight = 0.0
    noises: seq[seq[float]]
  for p in params:
    let amp = p.amp # p cannot be captured; p.amp is incmpatible with map
    totalWeight += amp
    noises &= map(singFreqNoise(p.freq, size), proc(n: float): float = n * amp)

  for i in 0..<size:
    var acc = 0.0
    for n in noises:
      acc += n[i]
    result &= acc/totalWeight

proc generateWorld*(w, h: Positive): World =
  let
    noiseX = noise(frequencies, w)
    noiseY = noise(frequencies, h)
  result = initWorld(w, h)
  for x in 0..<w:
    for y in 0..<h:
      if (noiseX[x] + noiseY[y])/2 > 0.6:
        result.lands[x, y] = Land()
      
randomize()

when isMainModule:
  echo singFreqNoise(1, 10)
  echo noise(frequencies, 30)
