extends RigidBody2D
class_name ChandelierBody

onready var animated_sprite = $AnimatedSprite as AnimatedSprite

func _ready():
	# we avoid checking Playing in the editor on animated sprites
	# because currently, Godot actually changes the frame property
	# in scene data during preview and that would be saved despite
	# not being a real change => so we play from script instead
	animated_sprite.play()
