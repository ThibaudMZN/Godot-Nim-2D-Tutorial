import godot
import godotapi / [global_constants, input_event, position_2d, animated_sprite, viewport, animation, sprite_frames, timer, packed_scene, path_follow_2d, node]
import player
import std/random
import std/math

gdobj Main of Node:
  var score: int
  var mob_scene {.gdExport.} : PackedScene
  var player: Player

  method init*() =
    self.player = self.getNode("Player") as Player

  method ready*() =
    discard self.connect("hit", self.player, "gameOver")
    self.newGame()

  proc gameOver*() {.gdExport.} =
    stop self.getNode("ScoreTimer") as Timer
    stop self.getNode("MobTimer") as Timer

  proc newGame*() {.gdExport.} =
    self.score = 0
    # self.player.start(self.getNode("StartPosition") as Position2D)
    start self.getNode("StartTimer") as Timer

  method onStartTimeout*() {.base.} =
    print("Start Timer")
    start self.getNode("ScoreTimer") as Timer
    start self.getNode("MobTimer") as Timer

  method onScoreTimeout*() {.base.} =
    print("Score Timer")
    self.score += 1

  method onMobTimeout*() {.base.} =
    print("Mob Timer")
    var mob = self.mob_scene.instance()

    var mob_spawn_location = self.getNode("MobPath/MobSpawnLocation") as PathFollow2D
    mob_spawn_location.offset = rand(1.0)
    var direction = mob_spawn_location.rotation + PI / 2

    discard mob.set("position", toVariant(mob_spawn_location.position))
    direction += rand(PI/2) - PI/4
    discard mob.set("rotation", toVariant(direction))

    var velocity = vec2(rand(50.0) + 150.0, 0.0)
    discard mob.set("linear_velocity", toVariant(velocity.rotated(direction)))

    self.addChild(mob)