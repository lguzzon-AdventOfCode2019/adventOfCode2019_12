

import strutils
import sequtils
import math

type
    Moon = tuple
        position: array[3, BiggestInt]
        velocity: array[3, BiggestInt]

const
    gcInputTest00 = """<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>"""
    gcStepsTest00 = 10

    gcInputTest01 = """<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>"""
    gcStepsTest01 = 100

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
                            lMoon.position[i] = v.parseBiggestInt
                        lMoon)

template newMoons(aMoons: seq[Moon]): seq[Moon] =
    block newMoons:
        var lNextMoons: seq[Moon]
        for (lMoonIndex, lMoon) in aMoons.pairs:
            lNextMoons.add(lMoon)
            for lIndex in ({0..aMoons.len.pred} - {lMoonIndex}):
                for (i, v) in (aMoons[lIndex].position.pairs):
                    if (lNextMoons[lMoonIndex].position[i] > v):
                        lNextMoons[lMoonIndex].velocity[i].dec
                    elif (lMoon.position[i] < v):
                        lNextMoons[lMoonIndex].velocity[i].inc
        lNextMoons.mapIt(
            block addVelocity:
                    var lMoon: Moon = it
                    for (i, v) in lMoon.velocity.pairs:
                        lMoon.position[i] = lMoon.position[i] + v
                    lMoon)


proc partOne =
    var lMoons = gcMoons
    for lStep in 1..gcSteps:
        lMoons = newMoons(lMoons)
    let lTotalEnergy = lMoons.foldl(a +
                                    (b.position.foldl(abs(a)+abs(b)) *
                                     b.velocity.foldl(abs(a)+abs(b))),
                                    0i64)
    echo "partOne:", lTotalEnergy


proc partTwo =
    var lMoons = gcMoons
    var lAxis = [0i64, 0i64, 0i64]
    var lStep = 0i64
    while lAxis.anyIt(it == 0i64):
        lMoons = newMoons(lMoons)
        lStep.inc
        if lStep mod 1000 == 0:
            echo lStep
        for (i, v) in lAxis.pairs:
            if (v == 0) and
                (lMoons.mapIt((it.position[i], it.velocity[i])) ==
                    gcMoons.mapIt((it.position[i], it.velocity[i]))):
                    lAxis[i] = lStep
    echo "partOne:", lAxis.foldl((a*b) div gcd(a, b))


partOne() #7722
partTwo() #292653556339368
