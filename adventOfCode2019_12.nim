
import strutils
import sequtils
import math

iterator combinations(n, r: Positive): seq[int] =
  var
    x = newSeq[int](r)
    stack = @[0]

  while stack.len > 0:
    var
      i = stack.high
      v = stack.pop()
    while v < n:
      x[i] = v
      inc v
      inc i
      stack.add(v)
      if i == r:
        yield x
        break

type
    Moon = tuple
        p: array[3, BiggestInt]
        v: array[3, BiggestInt]

const
    gcInputOk = """<x=-4, y=3, z=15>
<x=-11, y=-10, z=13>
<x=2, y=2, z=18>
<x=7, y=-1, z=0>"""
    gcStepsOk = 1000

    gcInput = gcInputOk
    gcSteps = gcStepsOk

    gcMoons = block Moons:
                  const lMoons = gcInput.split('\n').mapIt(
                    it.multiReplace(
                        ("<", ""),
                        (">", ""),
                        (" ", "")).split(',').mapIt(
                            it.split('=')[1])).mapIt(
                                block buildMoon:
                                    var lMoon: Moon
                                    for (i, v) in it.pairs:
                                        lMoon.p[i] = v.parseBiggestInt
                                    lMoon)
                  var lResult: array[lMoons.len, Moon]
                  for (i,v) in lMoons.pairs:
                    lResult[i]=v
                  lResult


    gcMoonsAxis = block MoonsAxis:
                      var lResult: array[3, array[gcMoons.len, (BiggestInt, BiggestInt)]]
                      for i in 0..2:
                        for (j, v) in gcMoons.mapIt((it.p[i], it.v[i])).pairs:
                          lResult[i][j] = v
                      lResult

    gcMoonCombinations = block MoonCombinations:
                             const lCombinations = toSeq(combinations(gcMoons.len, 2))
                             var lResult : array[lCombinations.len,array[2,int]]
                             for (i,v) in lCombinations.pairs:
                                 lResult[i][0]=v[0]
                                 lResult[i][1]=v[1]
                             lResult

template newMoons(aMoons: var array[gcMoons.len,Moon]) =
    block newMoons:
        for v in gcMoonCombinations.items:
          for a in 0..2:
            if (aMoons[v[0]].p[a] > aMoons[v[1]].p[a]):
              aMoons[v[0]].v[a].dec
              aMoons[v[1]].v[a].inc
            elif (aMoons[v[0]].p[a] < aMoons[v[1]].p[a]):
              aMoons[v[0]].v[a].inc
              aMoons[v[1]].v[a].dec
        for i in 0..aMoons.len.pred:
          for a in 0..2:
            aMoons[i].p[a] += aMoons[i].v[a]


proc partOne =
    var lMoons = gcMoons
    for lStep in 1..gcSteps:
        newMoons(lMoons)
    let lTotalEnergy = lMoons.foldl(a +
                                    (b.p.foldl(abs(a)+abs(b)) *
                                     b.v.foldl(abs(a)+abs(b))),
                                     0i64)
    echo "partOne:", lTotalEnergy


proc partTwo =
    var lMoons = gcMoons
    var lAxis = [0i64, 0i64, 0i64]
    var lStep = 0i64
    while lAxis.anyIt(it == 0i64):
        newMoons(lMoons)
        lStep.inc
        for (i, v) in lAxis.pairs:
            if (v == 0) and
                (lMoons.mapIt((it.p[i], it.v[i])) == gcMoonsAxis[i]):
                  lAxis[i] = lStep
    # [268296i64, 113028, 231614]
    echo "partOne:", lAxis.foldl((a*b) div gcd(a, b))


partOne() #7722
partTwo() #292653556339368
