extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_body_entered(body):
	var fireball = body as Fireball
	if fireball:
		# collision with fireball detected, destroy both entities
		fireball.queue_free()
		queue_free()
		
		# boss has been defeated, so player wins this mission
		GameManager.succeed_mission()
