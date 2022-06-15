import godot
import godotapi/[global_constants, input, input_event, position_2d,
    animated_sprite, viewport, animation]

import utils

defineGetter AnimatedSprite
defineGetter CollisionShape2D

gdobj Player of Area2D:
  var velocity: Vector2
  var screen_size: Vector2
  var speed {.gdExport.}: int
  var animated_sprite: AnimatedSprite
  var collisionShape: CollisionShape2D
  var counter: int

  method init*() =
    self.addUserSignal("hit")

  method ready*() =
    self.screen_size = self.getViewportRect.size
    self.animated_sprite = getAnimatedSprite("AnimatedSprite")
    self.collisionShape = getCollisionShape2D("CollisionShape2D")
    self.hide()

  method process*(delta: float64) =
    self.velocity.x = getActionStrength("move_right") - getActionStrength("move_left")
    self.velocity.y = getActionStrength("move_down") - getActionStrength("move_up")
    self.velocity = self.velocity.normalized * vec2(self.speed.float,
        self.speed.float)

    if self.velocity.length() > 0:
      self.position = self.position + self.velocity * delta
      self.position = vec2(clamp(self.position.x, 0.0, self.screen_size.x),
          clamp(self.position.y, 0.0, self.screen_size.y))
      play self.animated_sprite
      if self.velocity.x != 0:
        self.animated_sprite.animation = "walk"
      elif self.velocity.y != 0:
        self.animated_sprite.animation = "up"
      self.animated_sprite.flipV = (self.velocity.y > 0)
      self.animated_sprite.flipH = (self.velocity.x < 0)
    else:
      stop self.animated_sprite

  method onBodyEntered*(body: KinematicBody) {.base.} =
    self.hide()
    self.emitSignal("hit")
    self.collisionShape.setDeferred("disabled", toVariant(true))

  proc start*(position: Vector2) {.gdExport.} =
    self.position = position
    self.show()
    self.collisionShape.setDeferred("disabled", toVariant(false))

defineGetter Player
