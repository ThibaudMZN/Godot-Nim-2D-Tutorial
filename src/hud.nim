import godot
import godotapi / [global_constants, input_event, position_2d, animated_sprite, viewport, animation, sprite_frames, label, timer, button, scene_tree]

import utils

defineGetter Label
defineGetter Timer
defineGetter Button

gdobj Hud of CanvasLayer:

  method init*() =
    self.addUserSignal("start_game")

  proc showGameOver*() {.gdExport.} =
    getLabel("MessageLabel").text = "Game over"
    getLabel("MessageLabel").show()
    getButton("StartButton").show()

  proc updateScore*(score: int) {.gdExport.} =
    getLabel("ScoreLabel").text = $score

  method onStartPressed*() {.base.} =
    getLabel("MessageLabel").text = "Get Ready"
    getLabel("MessageLabel").show()
    getButton("StartButton").hide()
    getTimer("StartTimer").start()
    self.emitSignal("start_game")

  method onStartTimeout*() {.base.} =
    getLabel("MessageLabel").hide()

defineGetter Hud