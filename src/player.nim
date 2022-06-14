import godot
import godotapi / [global_constants, input_event, position_2d, animated_sprite, viewport, animation]

gdobj Player of Area2D:
  var velocity: Vector2
  var screen_size: Vector2
  var speed {.gdExport.}: int
  var animated_sprite: AnimatedSprite
  var collisionShape: CollisionShape2D

  method init*() =
    self.addUserSignal("hit")

  method ready*() =
    self.screen_size = self.getViewportRect().size
    self.animated_sprite = self.getNode("AnimatedSprite") as AnimatedSprite
    self.collisionShape = self.getNode("CollisionShape2D") as CollisionShape2D
    self.hide()

  method input*(event: InputEvent) =
    var velocity = vec2(0, 0)

    velocity.x = event.getActionStrength("move_right") - event.getActionStrength("move_left")
    velocity.y = event.getActionStrength("move_down") - event.getActionStrength("move_up");

    if velocity.length() > 0:
      velocity = velocity.normalized() * vec2(float self.speed, float self.speed)

    self.velocity = velocity

  method process*(delta: float64) =
    if self.velocity.length() > 0:
      self.position = self.position + self.velocity * delta
      self.position = vec2(clamp(self.position.x, 0.0, self.screen_size.x), clamp(self.position.y, 0.0, self.screen_size.y))
      self.animated_sprite.play()
      if self.velocity.x != 0:
        self.animated_sprite.animation = "walk"
        self.animated_sprite.flipV = false
        self.animated_sprite.flipH = (self.velocity.x < 0)
      elif self.velocity.y != 0:
        self.animated_sprite.animation = "up"
        self.animated_sprite.flipV = (self.velocity.y > 0)
    else:
      stop self.getNode("AnimatedSprite") as AnimatedSprite

  proc onPlayerBodyEntered*(body: KinematicBody) {.gdExport.} =
    self.hide()
    self.emitSignal("hit")
    self.collisionShape.setDeferred("disabled", toVariant(true))

  proc start(position: Vector2) {.gdExport.} =
    self.position = position
    self.show()
    self.collisionShape.setDeferred("disabled", toVariant(false))