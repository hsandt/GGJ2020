extends Node2D

export var chandelier_body_gravity_scale = 10.0

onready var chandelier_body = $ChandelierBody as RigidBody2D

# State
var is_body_detached = false

# Called when the node enters the scene tree for the first time.
func _ready():
	chandelier_body.gravity_scale = 0.0

func _on_Area2D_body_entered(body):
	var fireball = body as Fireball
	if fireball and not is_body_detached:
		# collision with fireball detected, destroy it
		fireball.queue_free()
		
		# detach chandelier body so it can fall
		self.is_body_detached = true
		call_deferred("detach_chandelier_body")

func detach_chandelier_body():
	var pos = chandelier_body.global_position
	
	# keep chandelier_body in Mission scene root (not global root)
	# so it gets removed when changing/reloading level
	remove_child(chandelier_body)
	owner.add_child(chandelier_body)
	
	chandelier_body.position = pos  # restore global position 
	chandelier_body.gravity_scale = chandelier_body_gravity_scale
	
