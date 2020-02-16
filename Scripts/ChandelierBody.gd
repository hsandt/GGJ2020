extends RigidBody2D
class_name ChandelierBody

onready var animated_sprite = $AnimatedSprite as AnimatedSprite

func _ready():
	# we avoid checking Playing in the editor on animated sprites
	# because currently, Godot actually changes the frame property
	# in scene data during preview and that would be saved despite
	# not being a real change => so we play from script instead
	animated_sprite.play()

func destroy():
	# finally decrement active count, as task transferred from MageRed is over
	GameManager.on_active_element_destroyed()
	print("chandelier died: " + str(GameManager.active_elements_count))
	queue_free()
