# Copyright 2017 Xored Software, Inc.

## Import independent scene objects here
## (no need to import everything, just independent roots)

when not defined(release):
  import segfaults # converts segfaults into NilAccessError

import player, mob, main, hud

export player, mob, main, hud
