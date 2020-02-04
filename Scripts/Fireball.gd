extends KinematicBody2D
class_name Fireball

# Parameter
var velocity : Vector2

func setup(position, setup_velocity):
	self.position = position
	self.velocity = setup_velocity

func _process(_delta):
	self.velocity = move_and_slide(self.velocity)
