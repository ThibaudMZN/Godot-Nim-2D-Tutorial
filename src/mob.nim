import godot
import godotapi / [global_constants, input_event, position_2d, animated_sprite, viewport, animation, sprite_frames]
import std/random

import utils

gdobj Mob of RigidBody2D:
  var animated_sprite: AnimatedSprite

  method ready*() =
    self.animated_sprite = self.getNode("AnimatedSprite") as AnimatedSprite
    self.animated_sprite.playing = true
    var mob_types = self.animated_sprite.frames.getAnimationNames()
    self.animated_sprite.animation = mob_types[rand(mob_types.len)]

  proc onVisibilityNotifier2DScreenExited*() {.gdExport.} =
    self.queueFree()

defineGetter Mob
