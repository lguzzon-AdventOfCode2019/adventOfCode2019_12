

import strutils
import sequtils

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


proc partOne =
    var lMoons = gcMoons
    for lStep in 1..gcSteps:
        var lNextMoons: seq[Moon]
        for (lMoonIndex, lMoon) in lMoons.pairs:
            lNextMoons.add(lMoon)
            for lIndex in ({0..lMoons.len.pred} - {lMoonIndex}):
                for (i, v) in (lMoons[lIndex].position.pairs):
                    if (lNextMoons[lMoonIndex].position[i] > v):
                        lNextMoons[lMoonIndex].velocity[i].dec
                    elif (lMoon.position[i] < v):
                        lNextMoons[lMoonIndex].velocity[i].inc
        lMoons = lNextMoons.mapIt(
            block addVelocity:
                var lMoon: Moon = it
                for (i, v) in lMoon.velocity.pairs:
                    lMoon.position[i] = lMoon.position[i] + v
                lMoon)
    let lTotalEnergy = lMoons.foldl(a +
                                    (b.position.foldl(abs(a)+abs(b)) *
                                     b.velocity.foldl(abs(a)+abs(b))),
                                    0i64)
    echo "partOne:", lTotalEnergy


proc partTwo =
    echo "partTwo:", 2

partOne() #7722
partTwo() #XXXX
