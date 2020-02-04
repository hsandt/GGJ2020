extends KinematicBody2D
class_name Fireball

# Parameter
var velocity : Vector2

func setup(position, velocity):
	self.position = position
	self.velocity = velocity

func _process(delta):
	move_and_slide(self.velocity)
