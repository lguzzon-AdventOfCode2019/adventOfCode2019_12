
import strutils
import sequtils
import math

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

    gcMoons = gcInput.split('\n').mapIt(
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

template newMoons(aMoons: seq[Moon]): seq[Moon] =
    block newMoons:
        var lNextMoons: seq[Moon]
        for (lMoonIndex, lMoon) in aMoons.pairs:
            lNextMoons.add(lMoon)
            for lIndex in ({0..aMoons.len.pred} - {lMoonIndex}):
                for (i, v) in (aMoons[lIndex].p.pairs):
                    if (lNextMoons[lMoonIndex].p[i] > v):
                        lNextMoons[lMoonIndex].v[i].dec
                    elif (lMoon.p[i] < v):
                        lNextMoons[lMoonIndex].v[i].inc
        lNextMoons.mapIt(
            block addv:
                var lMoon: Moon = it
                for (i, v) in lMoon.v.pairs:
                    lMoon.p[i] = lMoon.p[i] + v
                lMoon)


proc partOne =
    var lMoons = gcMoons
    for lStep in 1..gcSteps:
        lMoons = newMoons(lMoons)
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
        lMoons = newMoons(lMoons)
        lStep.inc
        for (i, v) in lAxis.pairs:
            if (v == 0) and
                (lMoons.mapIt((it.p[i], it.v[i])) ==
                 gcMoons.mapIt((it.p[i], it.v[i]))):
                lAxis[i] = lStep
    # [268296i64, 113028, 231614]
    echo "partOne:", lAxis.foldl((a*b) div gcd(a, b))


partOne() #7722
partTwo() #292653556339368
