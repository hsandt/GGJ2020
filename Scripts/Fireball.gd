extends KinematicBody2D

# Parameter
var velocity : Vector2

func setup(position, velocity):
	self.position = position
	self.velocity = velocity

func _process(delta):
	move_and_slide(self.velocity)
