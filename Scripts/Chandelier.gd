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
		fireball.destroy()
		
		# detach chandelier body so it can fall
		self.is_body_detached = true
		
		# Consider Chandelier body active until it hits the ground (or deadzone)
		# We are doing this *after* fireball destroy which may have already decremented
		#   the count to 0, but this is OK as we defer GameManager count check to next frame
		# We shouldn't increment the count in the call_deferred below, though, as it may
		# be later than the count check so the mission would end just as the chandelier body
		# starts falling. 
		GameManager.active_elements_count += 1
		print("chandelier detached! total active: " + str(GameManager.active_elements_count))
		
		call_deferred("detach_chandelier_body")

func detach_chandelier_body():
	var pos = chandelier_body.global_position
	
	# keep chandelier_body in Mission scene root (not global root)
	# so it gets removed when changing/reloading level
	remove_child(chandelier_body)
	owner.add_child(chandelier_body)
	
	chandelier_body.position = pos  # restore global position 
	chandelier_body.gravity_scale = chandelier_body_gravity_scale
	
