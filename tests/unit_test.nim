
import unittest

import adventOfCode2019_12
import adventOfCode2019_12/consts


suite "unit-test suite":
    test "getMessage":
        assert(cHelloWorld == getMessage())
