import godot
import godotapi / [global_constants, input_event, position_2d, animated_sprite,
    viewport, animation, sprite_frames, timer, packed_scene, path_follow_2d, node, rigid_body_2d, scene_tree]

import player, mob, hud, utils
import std/[random, math]

defineGetter Timer
defineGetter Position2d
defineGetter PathFollow2D

gdobj Main of Node:
  var score: int
  var mob_scene {.gdExport.}: PackedScene
  var player: Player
  var hud: Hud

  method ready*() =
    self.player = getPlayer("Player")
    self.hud = getHud("HUD")
    discard self.player.connect("hit", self, "_on_game_over")
    discard self.hud.connect("start_game", self, "_on_new_game")

  method onGameOver*() {.base.} =
    self.hud.showGameOver()
    stop getTimer("ScoreTimer")
    stop getTimer("MobTimer")

  method onNewGame*() {.base.} =
    discard self.getTree().callGroup("mobs", "queue_free")
    self.score = 0
    self.player.start(getPosition2d("StartPosition").position)
    self.hud.updateScore(self.score)
    start getTimer("StartTimer")

  method onStartTimeout*() {.base.} =
    start getTimer("ScoreTimer")
    start getTimer("MobTimer")

  method onScoreTimeout*() {.base.} =
    self.score += 1
    self.hud.updateScore(self.score)

  method onMobTimeout*() {.base.} =
    var mob = self.mob_scene.instance() as Mob

    var mob_spawn_location = getPathFollow2D("MobPath/MobSpawnLocation")
    mob_spawn_location.unitOffset = rand(1.0)
    var direction = mob_spawn_location.rotation + PI / 2

    mob.position = mob_spawn_location.position
    direction += rand(PI/2) - PI/4
    mob.rotation = direction

    var velocity = vec2(rand(50.0) + 150.0, 0.0)
    mob.linearVelocity = velocity.rotated(direction)

    self.addChild(mob)
