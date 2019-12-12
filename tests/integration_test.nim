
import unittest

when defined(js):
  discard
else:
  import os
  import osproc
  import strutils

  # import adventOfCode2019_12
  import adventOfCode2019_12/consts

  include "../scripts/nim/scriptsEnvVarNames.nimInc"

  suite "integration-test suite":
    test "getMessage excecuting the app":
      assert(cHelloWorld == execProcess(getEnv(gcApplicationToTestEnvVarName)).strip())
